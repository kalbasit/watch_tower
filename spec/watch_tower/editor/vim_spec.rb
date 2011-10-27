require 'spec_helper'

def mock_pipe(out)
  pipe = mock
  pipe.stubs(:read).returns(out)
  pipe.stubs(:close)
  pipe
end

module Editor
  describe Vim do
    before(:each) do
      # Stubs which
      WatchTower.stubs(:which).with('vim').returns('/usr/bin/vim')
      WatchTower.stubs(:which).with('gvim').returns('/usr/bin/gvim')
      WatchTower.stubs(:which).with('mvim').returns(nil)

      # Stub systemu
      Open3.stubs(:popen2).with("/usr/bin/vim --help").returns([mock_pipe(""), mock_pipe(""), mock_pipe("")])
      Open3.stubs(:popen2).with("/usr/bin/gvim --help").returns([mock_pipe(""), mock_pipe("--remote-send"), mock_pipe("")])
      Open3.stubs(:popen2).with("/usr/bin/gvim --servername VIM --remote-send ':source #{Vim::VIM_EXTENSION_PATH}<CR>'").returns([mock_pipe(""), mock_pipe(""), mock_pipe("")])
      Open3.stubs(:popen3).with("/usr/bin/gvim --servername VIM --remote-expr 'watchtower#ls()'").returns([mock_pipe(""), mock_pipe(<<-EOS), mock_pipe('')])
/path/to/file.rb
EOS
      Open3.stubs(:popen2).with('/usr/bin/gvim --serverlist').yields([mock_pipe(""), mock_pipe(<<-EOC), mock_pipe('')])
VIM
EOC
      version_output = <<-EOV
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

      Open3.stubs(:popen2).with("/usr/bin/vim --version").
        yields [mock_pipe(""), mock_pipe(version_output), mock_pipe('')]
      Open3.stubs(:popen2).with("/usr/bin/gvim --version").
        yields [mock_pipe(""), mock_pipe(version_output), mock_pipe('')]
    end

    it { should respond_to :name }
    its(:name) { should_not raise_error NotImplementedError }
    its(:name) { should_not be_empty }

    describe "#fetch_version" do
      it { should respond_to :fetch_version }

      it "should be called on initialize" do
        Vim.any_instance.expects(:fetch_version).once
        Vim.new
      end

      it "should return 7.3" do
        subject.send(:fetch_version).should == '7.3'
      end
    end

    it { should respond_to :version }
    its(:version) { should_not raise_error NotImplementedError }
    its(:version) { should_not be_empty }
    its(:version) { should == '7.3' }

    describe "#supported_vims" do
      it { should respond_to :supported_vims }

      it "should return gvim" do
        WatchTower.expects(:which).with('vim').returns('/usr/bin/vim').once
        WatchTower.expects(:which).with('gvim').returns('/usr/bin/gvim').once
        WatchTower.expects(:which).with('mvim').returns(nil).once
        Open3.expects(:popen2).with("/usr/bin/vim --help").returns([mock_pipe(""), mock_pipe(""), mock_pipe("")]).once
        Open3.expects(:popen2).with("/usr/bin/gvim --help").returns([mock_pipe(""), mock_pipe("--remote-send"), mock_pipe("")]).once

        subject.send :supported_vims
        subject.instance_variable_get('@vims').should == ['/usr/bin/gvim']
      end
    end

    describe "#editor" do
      it { should respond_to :editor }

      it "should return /usr/bin/gvim" do
        subject.send(:editor).should == '/usr/bin/gvim'
      end

      it "should return nil if @vims is []" do
        subject.instance_variable_set('@vims', [])

        subject.send(:editor).should == nil
      end

      it "should return nil if @vims is nil" do
        subject.instance_variable_set('@vims', nil)

        subject.send(:editor).should == nil
      end
    end

    describe "#servers" do
      it { should respond_to :servers }

      it "should return VIM" do
        Open3.expects(:popen2).with('/usr/bin/gvim --serverlist').yields([mock_pipe(""), mock_pipe(<<-EOC), mock_pipe('')]).once
VIM
EOC
        subject.send(:servers).should == ['VIM']
      end
    end

    describe "#send_extensions_to_editor" do
      it { should respond_to :send_extensions_to_editor }

      it "should send the extensions to vim" do
        Open3.expects(:popen2).with("/usr/bin/gvim --servername VIM --remote-send '<ESC>:source #{Vim::VIM_EXTENSION_PATH}<CR>'").once

        subject.send :send_extensions_to_editor
      end
    end

    describe "#is_running?" do
      it { should respond_to :is_running? }

      it "should return true if ViM is running" do
        subject.is_running?.should be_true
      end

      it "should return false if servers is []" do
        Vim.any_instance.stubs(:servers).returns([])

        subject.is_running?.should be_false
      end

      it "should return false if servers is nil" do
        Vim.any_instance.stubs(:servers).returns(nil)

        subject.is_running?.should be_false
      end
    end

    describe "#current_paths" do
      it { should respond_to :current_paths }

      it "should call is_running?" do
        Vim.any_instance.expects(:is_running?).returns(false).once

        subject.current_paths
      end

      it "should not call send_extensions_to_editor if the function is already loaded" do
        Vim.any_instance.expects(:send_extensions_to_editor).never

        subject.current_paths
      end

      it "should call send_extensions_to_editor only if the remote did not evaluate the command" do
        Open3.expects(:popen3).with("/usr/bin/gvim --servername VIM --remote-expr 'watchtower#ls()'").returns([mock_pipe(""), mock_pipe(""), mock_pipe(<<-EOS)]).twice
E449: Invalid expression received: Send expression failed.
EOS
        Vim.any_instance.expects(:send_extensions_to_editor).once

        subject.current_paths
      end

      it "should be nil if is_running? is false" do
        Vim.any_instance.stubs(:is_running?).returns(false)

        subject.current_paths.should be_nil
      end

      it "should be able to parse ls output" do
        Open3.expects(:popen3).with("/usr/bin/gvim --servername VIM --remote-expr 'watchtower#ls()'").returns([mock_pipe(""), mock_pipe(<<-EOS), mock_pipe('')]).once
/path/to/file.rb
/path/to/file2.rb
EOS

        documents = subject.current_paths
        documents.should include("/path/to/file.rb")
        documents.should include("/path/to/file2.rb")
      end

      it "should not return duplicate documents" do
        Open3.expects(:popen3).with("/usr/bin/gvim --servername VIM --remote-expr 'watchtower#ls()'").returns([mock_pipe(""), mock_pipe(<<-EOS), mock_pipe('')]).once
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
