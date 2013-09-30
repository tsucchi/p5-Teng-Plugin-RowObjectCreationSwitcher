Teng::Plugin::RowObjectCreationSwitcher - Teng's plugin which enables/disables suppress\_row\_objects with guard object.

# SYNOPSIS

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

# DESCRIPTION

Teng::Plugin::RowObjectCreationSwitcher is plugin for [Teng](http://search.cpan.org/perldoc?Teng) which provides switcher to enable/disable to generate row object.
This switcher returns guard object and if guard is dismissed, status is back to previous.

# METHODS

## $guard = $self->enable\_row\_object()

Disable suppress\_row\_objects status. (set suppress\_row\_object=0). This method returns guard object and guard is dismissed, status is back to previous. 

## $guard = $self->disable\_row\_object()

Enable suppress\_row\_objects status. (set suppress\_row\_object=1). This method returns guard object and guard is dismissed, status is back to previous. 



# LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takuya Tsuchida <tsucchi@cpan.org<gt>
