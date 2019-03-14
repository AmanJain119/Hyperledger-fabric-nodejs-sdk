module.exports = {
    name: 'API',
    env: process.env.NODE_ENV || 'development',
    port: process.env.PORT || 4000,
    //port: 8080,
    base_url: process.env.BASE_URL || 'http://localhost:4000',
};
