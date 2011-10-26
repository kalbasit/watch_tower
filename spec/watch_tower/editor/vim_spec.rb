require 'spec_helper'

module Editor
  describe Vim do
    before(:each) do
      # Stubs which
      WatchTower.stubs(:which).with('vim').returns('/usr/bin/vim')
      WatchTower.stubs(:which).with('gvim').returns('/usr/bin/gvim')
      WatchTower.stubs(:which).with('mvim').returns(nil)

      # Stub systemu
      Vim.any_instance.stubs(:systemu).with("/usr/bin/vim --help").returns([0, "", ""])
      Vim.any_instance.stubs(:systemu).with("/usr/bin/gvim --help").returns([0, "--remote server", ""])
      Vim.any_instance.stubs(:systemu).with("/usr/bin/gvim --servername VIM --remote-send ':source #{Vim::VIM_EXTENSION_PATH}<CR>'")
      Vim.any_instance.stubs(:systemu).with("/usr/bin/gvim --servername VIM --remote-expr 'watchtower#ls()'").returns([0, <<-EOS, ''])
/path/to/file.rb
EOS
      Vim.any_instance.stubs(:systemu).with('/usr/bin/gvim --serverlist').returns([0, <<-EOC, ''])
VIM
EOC
      Vim.any_instance.stubs(:systemu).with("/usr/bin/gvim --version").
        returns [0, <<-EOV, '']
VIM - Vi IMproved 7.3 (2010 Aug 15)
Included patches: 1-202, 204-222, 224-322
Compiled by 'http://www.opensuse.org/'
Huge version without GUI.  Features included (+) or not (-):
+arabic +autocmd -balloon_eval -browse ++builtin_terms +byte_offset +cindent
-clientserver -clipboard +cmdline_compl +cmdline_hist +cmdline_info +comments
+conceal +cryptv +cscope +cursorbind +cursorshape +dialog_con +diff +digraphs
-dnd -ebcdic +emacs_tags +eval +ex_extra +extra_search +farsi +file_in_path
+find_in_path +float +folding -footer +fork() +gettext -hangul_input +iconv
+insert_expand +jumplist +keymap +langmap +libcall +linebreak +lispindent
+listcmds +localmap -lua +menu +mksession +modify_fname +mouse -mouseshape
+mouse_dec -mouse_gpm -mouse_jsbterm +mouse_netterm -mouse_sysmouse
+mouse_xterm +multi_byte +multi_lang -mzscheme +netbeans_intg +path_extra -perl
 +persistent_undo +postscript +printer +profile -python -python3 +quickfix
+reltime +rightleft -ruby +scrollbind +signs +smartindent +sniff +startuptime
+statusline -sun_workshop +syntax +tag_binary +tag_old_static -tag_any_white
-tcl +terminfo +termresponse +textobjects +title -toolbar +user_commands
+vertsplit +virtualedit +visual +visualextra +viminfo +vreplace +wildignore
+wildmenu +windows +writebackup -X11 -xfontset -xim -xsmp -xterm_clipboard
-xterm_save
   system vimrc file: "/etc/vimrc"
     user vimrc file: "$HOME/.vimrc"
      user exrc file: "$HOME/.exrc"
  fall-back for $VIM: "/etc"
 f-b for $VIMRUNTIME: "/usr/share/vim/current"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H   -I/usr/local/include  -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g -Wall -pipe -fno-strict-aliasing -fstack-protector-all
Linking: gcc   -L/usr/local/lib -Wl,--as-needed -o vim       -lm -lnsl  -lncurses -lacl -lattr -ldl
EOV
    end

    it { should respond_to :name }
    its(:name) { should_not raise_error NotImplementedError }
    its(:name) { should_not be_empty }

    it { should respond_to :version }
    its(:version) { should_not raise_error NotImplementedError }
    its(:version) { should_not be_empty }
    its(:version) { should == '7.3' }

    describe "#supported_vims" do
      it { should respond_to :supported_vims }

      it "should return gvim" do
        Vim.any_instance.expects(:systemu).with("/usr/bin/vim --help").returns([0, "", ""]).once
        Vim.any_instance.expects(:systemu).with("/usr/bin/gvim --help").returns([0, "--remote server", ""]).once
        WatchTower.expects(:which).with('vim').returns('/usr/bin/vim').once
        WatchTower.expects(:which).with('gvim').returns('/usr/bin/gvim').once
        WatchTower.expects(:which).with('mvim').returns(nil).once

        subject.send :supported_vims
        subject.instance_variable_get('@vims').should == ['/usr/bin/gvim']
      end
    end

    describe "#editor" do
      it { should respond_to :editor }

      it "should return /usr/bin/gvim" do
        subject.send(:editor).should == '/usr/bin/gvim'
      end
    end

    describe "#servers" do
      it { should respond_to :servers }

      it "should return VIM" do
        Vim.any_instance.expects(:systemu).with('/usr/bin/gvim --serverlist').returns([0, <<-EOC, '']).once
VIM
EOC
        subject.send(:servers).should == ['VIM']
      end
    end

    describe "#send_extensions_to_editor" do
      it { should respond_to :send_extensions_to_editor }

      it "should send the extensions to vim" do
        Vim.any_instance.expects(:systemu).with("/usr/bin/gvim --servername VIM --remote-send ':source #{Vim::VIM_EXTENSION_PATH}<CR>'").once

        subject.send :send_extensions_to_editor
      end
    end

    describe "#is_running?" do
      it { should respond_to :is_running? }

      it "should return true if ViM is running" do
        subject.is_running?.should be_true
      end
    end

    describe "#current_paths" do
      it { should respond_to :current_paths }

      it "should call is_running?" do
        Vim.any_instance.expects(:is_running?).returns(false).once

        subject.current_paths
      end

      it "should call send_extensions_to_editor" do
        Vim.any_instance.expects(:send_extensions_to_editor).once

        subject.current_paths
      end

      it "should be nil if is_running? is false" do
        Vim.any_instance.stubs(:is_running?).returns(false)

        subject.current_paths.should be_nil
      end

      it "should be able to parse ls output" do
        Vim.any_instance.expects(:systemu).with("/usr/bin/gvim --servername VIM --remote-expr 'watchtower#ls()'").returns([0, <<-EOS, '']).once
/path/to/file.rb
/path/to/file2.rb
EOS

        documents = subject.current_paths
        documents.should include("/path/to/file.rb")
        documents.should include("/path/to/file2.rb")
      end

      it "should not return duplicate documents" do
        Vim.any_instance.expects(:systemu).with("/usr/bin/gvim --servername VIM --remote-expr 'watchtower#ls()'").returns([0, <<-EOS, '']).once
/path/to/file.rb
/path/to/file.rb
/path/to/file.rb
/path/to/file.rb
/path/to/file.rb
EOS

        documents = subject.current_paths
        documents.should include("/path/to/file.rb")
        documents.size.should == 1
      end
    end

  end
end
