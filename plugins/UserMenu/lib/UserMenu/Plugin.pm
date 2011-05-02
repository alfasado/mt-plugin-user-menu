package UserMenu::Plugin;

use strict;

sub _pre_run {
    my $app = MT->instance;
    if ( $app->mode ne 'dashboard' ) {
        return;
    }
    my $menus = MT->registry( 'applications', 'cms', 'menus' );
    for my $menu ( values( %$menus ) ) {
        if ( $menu->{ view } ) {
            if ( ( ref ( $menu->{ view } )
                && grep( $_ eq 'system', @{ $menu->{ view } } ) ) ) {
                if ( ref ( $menu->{ view } ) ) { 
                    my @scope = @{ $menu->{ view } };
                    push ( @scope, 'user' );
                    $menu->{ view } = \@scope;
                    $menu->{ view } = [ 'system', 'user' ];
                }
            } else {
                if ( $menu->{ view } eq 'system' ) {
                    $menu->{ view } = [ 'system', 'user' ];
                }
            }
        }
    }
    if (! MT->config( 'RemovableThisIsYouWidget' ) ) {
        return;
    }
    my $core = MT->component( 'core' );
    my $r;
    eval { $r = $core->registry( 'applications', 'cms', 'widgets' ) };
    if (! $@ ){
        my $plugin = MT->component( 'UserMenu' );
        require File::Spec;
        MT->config( 'AltTemplatePath', File::Spec->catdir( $plugin->path, 'alt-tmpl' ) );
            $r->{ this_is_you } = { label => 'This is You',
                                    template => 'widget/this_is_you.tmpl',
                                    handler  => "MT::CMS::Dashboard::this_is_you_widget",
                                    set => 'sidebar',
                                    singular => 1,
                                    view => 'user', };
    }
    return 1;
}

1;