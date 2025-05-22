# Install Esbuild, Jsbundling
```bash
./bin/bundle add jsbundling-rails
./bin/rails javascript:install:esbuild
```

# JWT
- [JSON Web Token Claims](https://auth0.com/docs/secure/tokens/json-web-tokens/json-web-token-claims)
- `jti` (JWT ID): The unique identifier for the token
- `exp` (expiration time): Time after which the JWT expires
  - Exact point in time token expires
  - Checked by server to reject expired tokens
## JWT Testing
  - URL: http://127.0.0.1:3000/api/users/me
    - Method: POST
    - Body: 
      ```json 
      {
        "email": "abc@gmail.com",
        "password": "abc@123456"
      }
      ```
    - Response:
      ```json
       {
       "access_token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDc5MzAzODgsImp0aSI6IjIyN2M2NDFiLTA0NjMtNGQwZS05MmRlLTYxNzFiMzY5MjhmMyJ9.yoKwEif_-EJpuA-wrFqFD19CXybk_SuaATpy_sY367U",
       "refresh_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDg1MzQzNTEsImp0aSI6ImVkN2RmMTU3LTdkYjctNGYyOS04NjAyLTJjMDFlNDYyNDk1NyJ9.S-hBI1KWsrsrrTkJcy4AumRa7_gwqxyod59AepKdDtI",
       "expires_in":900
      }
      ```
- URL: http://127.0.0.1:3000/api/users/current
    - Method: POST
    - Header:
      - Authorization:
        - Bearer Token: `access_token`
    - Response:
      ```json
        {
        "id": 1,
        "email": "abc@gmail.com",
        "created_at": "2025-05-22T15:40:58.220Z"
        }
      ```
- URL: http://127.0.0.1:3000/api/users/refresh
  - Method: POST
  - Body:
    ```json 
    {
    "refresh_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDg1MzQzNTEsImp0aSI6ImVkN2RmMTU3LTdkYjctNGYyOS04NjAyLTJjMDFlNDYyNDk1NyJ9.S-hBI1KWsrsrrTkJcy4AumRa7_gwqxyod59AepKdDtI",
    }
    ```
  - Response:
    ```json
     {
    "access_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDc5MzA3MTUsImp0aSI6IjBkYTIwYjFhLTk5ZmItNDVjOS05ZDcxLTllMmNiNzgxMGIyYyJ9.aW4M73X59WF9I1YCzXj5Qm_0VxS0dN_bYikN47opL34",
    "refresh_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDg1MzQ2MTUsImp0aSI6IjQxOTk1ZWExLTZhNjctNDU5Ny05MGY0LWNlMGJkOTQ0OGMyMCJ9.Rpk7HuVJ64inHW9sNrA8LEpL8f0zf4fZAZtSdiSU2TU",
    "expires_in": 900
    }
    ```

# Revoke Refresh Token
- Add refresh_token to Blacklist
```ruby
rails8(dev)> rf = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDg1MzQzNTEsImp0aSI6ImVkN2RmMTU3LTdkYjctNGYyOS04NjAyLTJjMDFlNDYyNDk1NyJ9.S-hBI1KWsrsrrTkJcy4AumRa7_gwqxyod59AepKdDtI"
rails8(dev)> JwtService.revoke(rf)
#<Blacklist:0x000079e877276e18
id: 1,
  token: "[FILTERED]",
  created_at: "2025-05-22 16:34:58.286722000 +0000",
  updated_at: "2025-05-22 16:34:58.286722000 +0000">

```
- Try again with refresh token
  - URL: http://127.0.0.1:3000/api/users/refresh
      - Method: POST
      - Body:
        ```json 
        {
        "refresh_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDg1MzQzNTEsImp0aSI6ImVkN2RmMTU3LTdkYjctNGYyOS04NjAyLTJjMDFlNDYyNDk1NyJ9.S-hBI1KWsrsrrTkJcy4AumRa7_gwqxyod59AepKdDtI",
        }
        ```
      - Response:
        ```json
          {
          "error": "Refresh token revoked"
          }
        ```
