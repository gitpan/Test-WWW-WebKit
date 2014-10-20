package Test::WWW::WebKit;

=head1 NAME

Test::WWW::WebKit - Perl extension for using an embedding WebKit engine for tests

=head1 SYNOPSIS

    use Test::WWW::WebKit;

    my $webkit = Test::WWW::WebKit->new(xvfb => 1);
    $webkit->init;

    $webkit->open_ok("http://www.google.com");
    $webkit->type_ok("q", "hello world");
    $webkit->click_ok("btnG");
    $webkit->wait_for_page_to_load_ok(5000);
    $webkit->title_is("foo");

=head1 DESCRIPTION

Test::WWW::WebKit is a drop-in replacement for Test::WWW::Selenium using Gtk3::WebKit as browser instead of relying on an external Java server and an installed browser.

=head2 EXPORT

None by default.

=cut

use 5.10.0;
use Moose;

extends 'WWW::WebKit';

use Glib qw(TRUE FALSE);
use Time::HiRes qw(time usleep);
use Test::More;

our $VERSION = '0.01';

sub open_ok {
    my ($self, $url) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $self->open($url);

    ok(1, "open_ok($url)");
}

sub refresh_ok {
    my ($self) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $self->refresh;
    ok(1, "refresh_ok()");
}

sub go_back_ok {
    my ($self) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $self->go_back;
    ok(1, "go_back_ok()");
}

sub select_ok {
    my ($self, $select, $option) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->select($select, $option), "select_ok($select, $option)");
}

sub click_ok {
    my ($self, $locator) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->click($locator), "click_ok($locator)");
}

sub wait_for_page_to_load_ok {
    my ($self, $timeout) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $self->wait_for_page_to_load($timeout);
}

sub wait_for_element_present_ok {
    my ($self, $locator, $timeout, $description) = @_;
    $description //= '';
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $timeout ||= $self->default_timeout;

    ok($self->wait_for_element_present($locator, $timeout), "wait_for_element_present_ok($locator, $timeout, $description)");
}

sub wait_for_element_to_disappear_ok {
    my ($self, $locator, $timeout, $description) = @_;
    $description //= '';
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $timeout ||= $self->default_timeout;

    ok($self->wait_for_element_to_disappear($locator, $timeout), "wait_for_element_to_disappear_ok($locator, $timeout, $description)");
}

sub is_element_present_ok {
    my ($self, $locator) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $result = $self->is_element_present($locator);
    ok($result, "is_element_present_ok($locator)");
    warn "# $@\n" unless $result;
}

sub type_ok {
    my ($self, $locator, $text) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok(eval { $self->type($locator, $text) }, "type_ok($locator, $text)");
}

sub type_keys_ok {
    my ($self, $locator, $text) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok(eval { $self->type_keys($locator, $text) }, "type_keys_ok($locator, $text)");
}

sub control_key_down_ok {
    my ($self) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $self->control_key_down;
    ok(1, "control_key_down_ok()");
}

sub control_key_up_ok {
    my ($self) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $self->control_key_up;
    ok(1, "control_key_up_ok()");
}

sub is_ordered_ok {
    my ($self, $first, $second) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->is_ordered($first, $second), "is_ordered_ok($first, $second)");
}

sub mouse_over_ok {
    my ($self, $locator) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->mouse_over($locator), "mouse_over_ok($locator)");
}

sub mouse_down_ok {
    my ($self, $locator) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->mouse_down($locator), "mouse_down_ok($locator)");
}

sub fire_event_ok {
    my ($self, $locator, $event_type) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->fire_event($locator, $event_type), "fire_event_ok($locator, $event_type)");
}

sub text_is {
    my ($self, $locator, $text, $description) = @_;
    $description //= '';
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    is($self->get_text($locator), $text, "text_is($locator, $text, $description)");
}

sub text_like {
    my ($self, $locator, $text) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    like($self->get_text($locator), $text);
}

sub body_text_like {
    my ($self, $text) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    like($self->get_body_text(), $text, "body_text_like($text)");
}

sub value_is {
    my ($self, $locator, $value) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    is($self->get_value($locator), $value, "value_is($locator, $value)");
}

sub title_like {
    my ($self, $text) = @_;

    like($self->get_title, $text, "title_like($text)");
}

sub is_visible_ok {
    my ($self, $locator) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->is_visible($locator), "is_visible($locator)");
}

sub attribute_like {
    my ($self, $locator, $expr) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    like($self->get_attribute($locator), $expr, "attribute_like($locator, $expr)");
}

sub attribute_unlike {
    my ($self, $locator, $expr) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    unlike($self->get_attribute($locator), $expr, "attribute_unlike($locator, $expr)");
}

sub submit_ok {
    my ($self, $locator) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    ok($self->submit($locator), "submit_ok($locator)");
}

=head2 Additions to the Selenium API

=head3 native_drag_and_drop_to_object_ok($source, $target)

Drag&drop test that works with native HTML5 D&D events.

=cut

sub native_drag_and_drop_to_object_ok {
    my ($self, $source, $target) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $self->native_drag_and_drop_to_object($source, $target);

    ok(1, "native_drag_and_drop_to_object_ok($source, $target)");
}

1;

=head1 SEE ALSO

L<WWW::Selenium> for the base package.
See L<Test::WWW::Selenium> for API documentation.
L<Test::WWW::WebKit::Catalyst> for a replacement for L<Test::WWW::Selenium::Catalyst>

=head1 AUTHOR

Stefan Seifert, E<lt>nine@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Stefan Seifert

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.

=cut
