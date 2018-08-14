function css_test(shortname) {
    promise_test(function(t) {
        return fetch(`/css/json/${shortname}.json`)
        .then(function(response) {
            assert_true(response.ok, 'fetch ok');
            return response.json();
        }).then(function(data) {
            for (let propertyName in data.properties) {
                test(() => {
                    assert_true(CSS.supports(`${propertyName}:initial`));
                }, `${propertyName} property`);
            }
        });
    }, 'css_test setup');
}
