#!perl
use strict;
use warnings;
use Test::More;
use t::Utils;
use Mock::Basic;

my $dbh = t::Utils->setup_dbh;
my $db = Mock::Basic->new({dbh => $dbh});
$db->load_plugin('RowObjectCreationSwitcher');
$db->setup_test_db;
$db->fast_insert('mock_basic',{
    id   => 1,
    name => 'perl',
});

my $condition = { name     => 'perl' };
my $option    = { order_by => 'id'   };


subtest 'disable_row_object', sub {

    my $row = $db->single('mock_basic', $condition, $option);
    ok( $row->isa('Teng::Row') );
    {
        my $guard = $db->disable_row_object();
        $row = $db->single('mock_basic', $condition, $option);
        is( $db->suppress_row_objects, 1 );
        is( ref $row, 'HASH' );
    }
    # dismiss guard
    $row = $db->single('mock_basic', $condition, $option);
    ok( $row->isa('Teng::Row') );

    $db->disable_row_object();
    $row = $db->single('mock_basic', $condition, $option);
    is( ref $row, 'HASH' );
};


subtest 'enable_row_object', sub {
    $db->disable_row_object();
    my $row = $db->single('mock_basic', $condition, $option);
    is( ref $row, 'HASH' );
    {
        my $guard = $db->enable_row_object();
        $row = $db->single('mock_basic', $condition, $option);
        ok( $row->isa('Teng::Row') );
    }
    # dismiss guard
    $row = $db->single('mock_basic', $condition, $option);
    is( ref $row, 'HASH' );

    $db->enable_row_object();
    $row = $db->single('mock_basic', $condition, $option);
    ok( $row->isa('Teng::Row') );
};


subtest 'nested guard', sub {
    my $row = $db->single('mock_basic', $condition, $option);
    ok( $row->isa('Teng::Row') );
    {
        my $guard = $db->disable_row_object();
        $row = $db->single('mock_basic', $condition, $option);
        is( ref $row, 'HASH' );
        {
            my $guard = $db->disable_row_object();
            $row = $db->single('mock_basic', $condition, $option);
            is( ref $row, 'HASH' );
        }
        $row = $db->single('mock_basic', $condition, $option);
        is( ref $row, 'HASH' );
    }
    # dismiss guard
    $row = $db->single('mock_basic', $condition, $option);
    ok( $row->isa('Teng::Row') );

};



done_testing();
