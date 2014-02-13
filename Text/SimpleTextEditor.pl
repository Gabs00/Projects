#!/usr/bin/perl
=About

	Code by: Gabs00
	Date: Feb 12 2014
	
	This is my first time using Tk and used a few different source materials to get an understanding of how to use it.
	http://docstore.mik.ua/orelly/perl3/tk/index.htm
	http://search.cpan.org/~srezic/Tk-804.032/Tk.pod
	http://www.perlmonks.org/?node_id=181977
	
=cut
use strict;
use warnings;
use Tk;
use TK::TextUndo;
use Tk::Dialog;


my $currentFile;

my $win = new MainWindow;
$win->geometry('600x800');
$win->configure(-menu => my $menubar = $win->Menu( ), -title => 'Simple Text Editor');

#Menubar items ie. file edit view etc bar 
my $file = $menubar->cascade(-label => '~File', -tearoff => 0);
#my $edit = $menubar->cascade(-label => '~Edit', -tearoff => 0);	#Not yet implemented, questionable whether it ever will be

#Sets up the help about menu
my $help = $menubar->cascade(-label => '~Help', -tearoff => 0);
$help->command(-label => 'About', -command => \&about);

#Menu items for file menu
my %filemenu = (
	"new" => [qw/New Ctrl-n 0/],
	"open" => [qw/Open Ctrl-o 0/],
	"save" => [qw/Save Ctrl-s 0/],
	"saveA" => ["Save As", qw/Ctrl-a 1/],
	"close" => [qw/Close Ctrl-w 0/]
);



#this for overwrites the previous values in the hash filemenu
for(qw/new open save saveA close/){
	$filemenu{$_} = menu_items($file, @{$filemenu{$_}});
}

my $text = $win->Scrolled('TextUndo',
			-scrollbars => 'se')->pack(-fill => 'both',
					           -expand => 1,
						   -side => 'bottom'
						   );
#events for once each button is used
$filemenu{'new'}->configure(-command => \&createNew);
$filemenu{'open'}->configure(-command => \&openFile);
$filemenu{'save'}->configure(-command => \&save);
$filemenu{'saveA'}->configure(-command => \&saveAs);
$filemenu{'close'}->configure(-command => \&exit);

#creating binding events for shortcut keys
$win->bind('Tk::TextUndo', '<Control-Key-n>',
			sub { createNew(); }
	);

$win->bind('Tk::TextUndo', '<Control-Key-o>',
			sub { openFile(); }
	);

$win->bind('Tk::TextUndo', '<Control-Key-s>',
			sub { save(); }
	);

$win->bind('Tk::TextUndo', '<Control-Key-a>',
			sub { saveAs(); }
	);

$win->bind('Tk::TextUndo', '<Control-Key-w>',
			sub { exit(); }
	);
	


				   

MainLoop;

#############################
###		Subroutines		#####
#############################


#creates menu items
sub menu_items {
	my $menus = shift;
	my ($label, $acc, $under) = @_;
	
	return $menus->command(
		-label => $label,
		-accelerator => $acc,
		-underline => $under
	);
	
}
sub createNew {
	my $choice = openDialog();
	if(defined($choice)){
		$text->delete('1.0', 'end');
	}
}
sub openFile {
	my $choice = openDialog();
	if(defined($choice)){
		my $file = $text->getOpenFile();
		if($file){
			$text->delete('1.0', 'end');
			open (my $fh, '<', $file) or die "Could not open file: $!";
			while(<$fh>){
				$text->insert('end', $_);
			}
			
			$currentFile = $file;
		}
	}
}

sub openDialog {
	my @items = ("Save","Save As","Discard");
	
	my $dialog = $win->Dialog(
		-title => 'Save current file?',
		-text => 'Save Current file?',
		-default_button => $items[0],
		-buttons => \@items,
	);
	
	my $button = $dialog->Show;
	
	if($button eq 'Save'){
		save();
	}
	elsif($button eq 'Save As'){
		saveAs();
	}
	
	return $button;
}
sub save {
	if ($currentFile){
		saveFile($currentFile);
	}
	else{
		saveAs();
	}
}

sub saveAs {
	my $file = $text->getSaveFile();
	saveFile($file);
}

sub saveFile {
	my $file = shift;
	if($file){
		open(my $fh, '>', $file) or die "Could not open save file: $!";
		print {$fh} $text->Contents();
		$currentFile = $file;
	}
}

sub about {
		my $about =$win->Dialog(
							-title => "About: Text Editor",
							-text => '',
							-buttons => ['ok'],
							);
		$about->configure(-text => "Program Name: Simple Text Editor\nCreated By: Gabs00\nDate: Feb. 12 2014");
		$about->Show;
}

