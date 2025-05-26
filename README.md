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
### JWT Testing
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

### Revoke Refresh Token
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
# Turbo Stream and Turbo Frame Demo
- Turbo Frames allow you to replace or update a part of the page without a full reload.
- Turbo Streams allow you to update parts of a page without a full reload.
### Turbo Stream
- http://localhost:3000/:
  - Notification will be appended to the page when you create a new notification from rails console
  - Existed notifications are loaded to the page when you visit the root URL.
  - Open Rails console:
    ```ruby
      Notification.create(title: "New Notification", text: "This is a new notification created from the console.")
    ```
- http://localhost:3000/posts:
  - Test the turbo stream with the post creation form.
  - New post will be appended to the `Newly Created Post From Turbo Stream`

# Stimulus JS
- http://localhost:3000/:
  - Notification status can be toggled by clicking the "X" button.
  - Stimulus controller will send an AJAX request to update the notification status.

# TailWind Customization
### Extending tailwind.config.js
- Example of customizing the Tailwind configuration:
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ['./app/**/*.html.erb', './app/helpers/**/*.rb', './app/javascript/**/*.{js,jsx}'],
    theme: {
    extend: {
      colors: {
        'brand-primary': '#FF5733', // Custom primary color
        'brand-secondary': '#33FF57', // Custom secondary color
        'custom-gray': { // Custom gray scale
          100: '#f7fafc',
          200: '#edf2f7',
          // ... more shades
          900: '#1a202c',
        },
      },
      spacing: {
        '72': '18rem', // Custom spacing unit
        '84': '21rem',
        '96': '24rem',
      },
      fontSize: {
        'xxs': '0.625rem', // Extra extra small font size
        '7xl': '5rem', // Custom large font size
      },
      fontFamily: {
        'sans': ['Inter', 'sans-serif'], // Extend default sans-serif
        'heading': ['Montserrat', 'sans-serif'], // Custom heading font
      },
      borderRadius: {
        '4xl': '2rem', // Custom border radius
      },
      // You can extend other properties like screens, boxShadow, etc.
      screens: {
        '3xl': '1600px', // Custom breakpoint
      },
    },
  },
  plugins: [],
}
```
## Adding Custom CSS with @layer Directive
### For the typical Rails + Tailwind project,
the most straightforward and recommended approach is to:
- Customize your theme in config/tailwind.config.js.
- Add your custom @layer base, @layer components, and @layer utilities rules directly into app/assets/tailwind/application.css (after @import "tailwindcss";).
- Use arbitrary values in your HTML for one-off styles:
- Example of using arbitrary values in HTML:
```html
<div class="w-[345px] top-[117px] bg-[#abcdef] text-[clamp(1rem,2vw,2rem)] grid grid-cols-[1fr_200px_1fr] [mask-type:luminance]">
  <!-- Your content here -->    
</div>
```

### Explanation of @layer:
@import the custom CSS file in your app/assets/tailwind/application.css. They should contain @layer directives.

```css
@import "./components/buttons.css";
```
- @layer base: For global base styles, resets, or default styles applied to plain HTML elements. Tailwind's Preflight (its opinionated base styles) also lives in this layer.
- @layer components: For reusable, class-based styles that you intend to be overridable by utility classes. Think of common UI components like buttons, cards, forms, etc.
- @layer utilities: For small, single-purpose classes that should generally take precedence over other styles. This is where you'd add completely new utility classes not provided by Tailwind
  - @apply: For applying Tailwind utility classes to your custom CSS selectors. This is useful for creating custom components or styles that leverage Tailwind's utility-first approach.
```css
@layer components {  
    .btn {
    @apply px-4 py-2 bg-blue-500 text-white rounded;
  }  
    .card {
    @apply p-6 bg-white shadow-md rounded-lg;
    }
}
```
