package UserMenu::Plugin;

use strict;

sub _pre_run {
    my $app = MT->instance;
    if ( $app->mode ne 'dashboard' ) {
        return;
    }
    my $menus = MT->registry( 'applications', 'cms', 'menus' );
                use Data::Dumper;
    for my $menu ( values( %$menus ) ) {
        if ( my @scope = $menu->{ view } ) {
            if ( ( ref ( $menu->{ view } )
                && grep( $_ eq 'system', @{ $menu->{ view } } ) ) ) {
                my @scope = $menu->{ view };
                push ( @scope, 'user' );
                $menu->{ view } = \@scope;
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