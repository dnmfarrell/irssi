#!/usr/bin/env perl

use 5.10.0;
use vars qw($VERSION %IRSSI);
use Gtk3::Notify -init, "irssi";
use Irssi;

$VERSION = '0.0.1';

%IRSSI = (
    authors     => 'David Farrell',
    contact     => 'perltricks.com@gmail.com',
    name        => 'gnotify',
    description => 'Creates Gnome3 popup alert when your nick is mentioned or you are private messaged',
    url         => 'https://github.com/sillymoose/irssi/blob/master/gnotify.pl',
    license     => 'GNU General Public License',
    changed     => '$Date: 2014-05-31 20:44:00 -0400 (Sat, 31 May 2014) $'
);

=head1 DESCRIPTION

This is an irssi script that creates a Gnome3 alert popup in your window when your nick is mentioned or you are private messaged.

=head1 INSTALLATION

Place this file in your user irrsi directory, e.g:

    ~/.irssi/script/gnotify.pl

Within irrsi you can load the script:

    /script load gnotify.pl

You can also create a simlink to autoload the script when irssi starts:

    $ mkdir ~/.irssi/script/autorun
    $ cd ~/.irssi/script/autorun
    $ ln -s ../gnotify.pl

=cut

=head1 SUBROUTINES

=head2 priv_msg

Called when you get a private message. Calls alert()

=cut

sub priv_msg {
    my ($server,$msg,$nick,$address,$target) = @_;
    alert($nick." " .$msg );
}

=head2 priv_msg

Called when your nick is mentioned. Calls filewrite() and alert()

=cut

sub hilight {
    my ($dest, $text, $stripped) = @_;
    if ($dest->{level} & MSGLEVEL_HILIGHT) {
    alert($dest->{target}. " " .$stripped );
    }
}

=head2 alert

Creates the popup alert!

=cut

sub alert {
    my $notification = Gtk3::Notify::Notification->new('New irssi message', shift);
    $notification->show;
}

# binds subs to Irssi signal / events

Irssi::signal_add_last("message private", "priv_msg");
Irssi::signal_add_last("print text", "hilight");

=head1 THANKS

Based on fnotify.pl by Thorsten Leemhuis

=cut

=head1 WARNING

Gtk3::Notify v0.01 test file *may* not work on install. I've filed a patch with the author, but in meantime if you need to install Gtk3::Notify:

    $ cpan -g Gtk3::Notify
    $ tar xvf Gtk3-Notify-0.01.tar.gzf
    $ cd Gtk3-Notify-0.01
    $ rm t/*
    $ perl Makefile.PL
    $ make
    $ make test
    $ make install

Voila!

Bear in mind that Gtk3 has some C dependencies which you'll need to install. My yum log shows I installed:

    glib-devel
    perl-Glib-devel
    libtool
    gobject-introspection
    gobject-introspection-devel
    perl-Cairo
    perl-Cairo-GObject
    cairo-gobject-devel

There may be more!

=cut
