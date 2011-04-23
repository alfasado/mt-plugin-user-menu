package UserMenu::Plugin;

use strict;

sub _pre_run {
    my $app = MT->instance;
    if ( $app->mode ne 'dashboard' ) {
        return;
    }
    my $menus = MT->registry( 'applications', 'cms', 'menus' );
    if ( MT->version_id !~ /^5\.0/ ) {
        my $menus = MT->registry( 'applications', 'cms', 'menus' );
        my @sys_menu = qw( blog:manage entry:manage page:manage asset:manage
                          feedback:comment feedback:ping filter:member commenter:manage );
        for my $menu ( @sys_menu ) {
            $menus->{ $menu }->{ view } = [ 'user', 'system', 'website', 'blog' ];
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