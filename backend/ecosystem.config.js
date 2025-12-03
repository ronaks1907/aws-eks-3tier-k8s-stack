module.exports = {
  apps: [
    {
      name: "backend-3tier",
      script: "src/server.js",
      watch: false,
      env: {
        NODE_ENV: "development"
      },
      env_production: {
        NODE_ENV: "production"
      }
    }
  ]
};
