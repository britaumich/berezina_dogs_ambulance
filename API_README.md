# Berezina Dogs Ambulance API Documentation

## Secure API Architecture

This application now provides a dedicated API namespace that eliminates CSRF vulnerabilities by using token-based authentication instead of cookie-based sessions.

## API Endpoints

### Authentication
- `POST /api/session` - Login and receive API token
- `DELETE /api/session` - Logout (invalidate token)

### Data Access
- `GET /api/animals` - Get animals data (JSON or CSV format)

## Security Features

✅ **Token-based authentication** - No cookie dependencies  
✅ **CSRF protection** - API controllers skip CSRF (safe with tokens)  
✅ **Separate namespace** - Clear separation from web interface  
✅ **Same authorization** - Uses existing Pundit policies  
✅ **Token expiration** - Tokens expire after 30 days  

## Usage Examples

### 1. Authentication
```bash
curl -X POST http://localhost:3000/api/session \
  -H "Content-Type: application/json" \
  -d '{"email_address":"your@email.com","password":"yourpassword"}'

# Response:
# {"token":"token","user_email":"your@email.com","expires_at":"2026-04-16T..."}
```

### 2. Get CSV Data
```bash
curl -H "Authorization: Bearer YOUR-TOKEN-HERE" \
     -H "Accept: text/csv" \
     http://localhost:3000/api/animals.csv
```

### 3. Get JSON Data
```bash
curl -H "Authorization: Bearer YOUR-TOKEN-HERE" \
     -H "Accept: application/json" \
     http://localhost:3000/api/animals
```

## Quick Start Script

Run the provided example script:
```bash
./api_example.sh
```

Edit the script to use your actual credentials:
- `EMAIL="your@email.com"`
- `PASSWORD="yourpassword"`

## API Controller Architecture

```
app/controllers/api/
├── base_controller.rb      # Base API controller with token auth
├── sessions_controller.rb  # API authentication endpoints  
└── animals_controller.rb   # API data access endpoints
```

## Migration from Previous Setup

The previous approach of disabling CSRF protection has been removed:

### ❌ Old (Insecure):
- Modified `SessionsController` with `skip_forgery_protection`
- Mixed web and API authentication in same controller
- CSRF vulnerability risk

### ✅ New (Secure):
- Dedicated API namespace with token authentication
- Clear separation between web and API interfaces
- No CSRF vulnerabilities
- Clean architecture

## Account Setup
- Create account to run API

## Token Management

- Tokens are session IDs from the `sessions` table
- Tokens expire after 30 days
- API calls automatically authenticate via `Authorization: Bearer TOKEN` header
- Use HTTP Token Authentication as per Rails conventions

## Error Responses

All API endpoints return structured JSON errors:

```json
{
  "error": "Unauthorized"          // 401
  "error": "Access denied"         // 403  
  "error": "Not found"            // 404
  "error": "Internal server error" // 500
}
```

## Production Considerations

1. **Use HTTPS** in production to protect tokens in transit
2. **Token rotation** - Implement shorter token lifespans for high security
3. **Rate limiting** - Consider API-specific rate limits
4. **Monitoring** - Log API access for security monitoring
5. **API versioning** - Consider `/api/v1/` namespace for future changes
