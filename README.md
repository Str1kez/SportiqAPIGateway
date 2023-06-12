# API Gateway for Sportiq project

This is the API Gateway for the Sportiq project. Supports CORS-headers operations and JWT authentication via connection with KDS and modules on Lua language.

![Project Architecture](assets/diagram.png#gh-dark-mode-only)
![Project Architecture](assets/Pasted%20image%2020230510002251.png#gh-light-mode-only)

## Related Sportiq services

- [User Service](https://github.com/Str1kez/SportiqUserService)
- [Event Service](https://github.com/Str1kez/SportiqEventService)
- [Subscription Service](https://github.com/Str1kez/SportiqSubscriptionService)
- [Frontend App](https://github.com/Str1kez/SportiqReactApp)

## Startup

1. Create `.env` file and fill it:
   ```commandline
   make env
   ```
2. Build Docker-image:
   ```commandline
   make build
   ```
3. (Optional) make self-signed SSL certificate:
   ```commandline
   make ssl
   ```
4. After the start of all microservices:
   ```commandline
   make up
   ```

## Development

Reloading can be helpful:

```commandline
make reload
```
