use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'DoQueue' }

ok(request('/')->is_success, '/ is ok');
is(request('/made-up-url')->code, 404, 'bogus request should 404');
