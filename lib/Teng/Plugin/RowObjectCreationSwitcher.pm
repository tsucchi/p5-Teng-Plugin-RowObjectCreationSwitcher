package Teng::Plugin::RowObjectCreationSwitcher;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

use Scope::Guard;

our @EXPORT = qw(enable_row_object disable_row_object);

sub enable_row_object {
    my ($self, $new_status) = @_;
    return Teng::Plugin::RowObjectCreationSwitcher::_set_suppress_row_objects($self, 0);
}

sub disable_row_object {
    my ($self, $new_status) = @_;
    return Teng::Plugin::RowObjectCreationSwitcher::_set_suppress_row_objects($self, 1);
}


sub _set_suppress_row_objects {
    my ($self, $new_status) = @_;

    my $current_status = $self->suppress_row_objects(); #preserve current(for guard object)
    $self->suppress_row_objects($new_status);

    return if ( !defined wantarray() );

    return Scope::Guard->new(sub { 
        $self->suppress_row_objects($current_status);
    });
}



1;
__END__

=encoding utf-8

Teng::Plugin::RowObjectCreationSwitcher - Teng's plugin which enables/disables suppress_row_objects with guard object.

=head1 SYNOPSIS

    use MyProj::DB;
    use parent qw(Teng);
    __PACKAGE__->load_plugin('RowObjectCreationSwitcher');

    package main;
    my $db = MyProj::DB->new(dbh => $dbh);
    {
        my $guard = $db->disable_row_object(); # disable to generate row object(suppress_row_objects is 1)
        {
            my $guard2 = $db->enable_row_object(); # enable again(suppress_row_objects is 0)
            ... # do something
        }
        # dismiss $guard2 (row object is disabled)
        ... # do something
    }
    # dismiss $guard (row object is enabled)

=head1 DESCRIPTION

Teng::Plugin::RowObjectCreationSwitcher is plugin for L<Teng> which provides switcher to enable/disable to generate row object.
This switcher returns guard object and if guard is dismissed, status is back to previous.

=head1 METHODS

=head2 $guard = $self->enable_row_object()

Disable suppress_row_objects status. (set suppress_row_object=0). This method returns guard object and guard is dismissed, status is back to previous. 

=head2 $guard = $self->disable_row_object()

Enable suppress_row_objects status. (set suppress_row_object=1). This method returns guard object and guard is dismissed, status is back to previous. 


=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.org<gt>

=cut

