function karateConfig() {
    karate.configure('connectTimeout', 15000);
    karate.configure('readTimeout', 75000);
    karate.configure('retry',{ count:4, interval:4000});

    return {
        demoUrl: 'http://127.0.0.1:8900/',
        // demoUrl: karate.properties['base.URL'],
    };
}