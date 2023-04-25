# Admin Panel

This package provides a simple admin panel for your [Vapor](https://vapor.codes) application.

## 📦 Installation
Add `AdminPanel` to your package dependencies (in your `Package.swift` file):

```swift
dependencies: [
    // ...
    .package(url: "https://github.com/brokenhandsio/admin-panel", from: "1.0.0-beta")
]
```

as well as to your target:
```swift
.product(name: "AdminPanel", package: "admin-panel")
```

## 🚀 Getting started
Import the package in your `configure.swift` file:

```swift
import AdminPanel
```

Then you can configure the admin panel:

```swift
app.adminPanel.config = .init(
    name: "your-app",
    baseURL: "http://127.0.0.1:8080",
    environment: app.environment
)
```
## Examples

![Login screen](https://user-images.githubusercontent.com/944158/63353860-b0fc1580-c363-11e9-881c-fec19874b4c0.png)

![Successful login](https://user-images.githubusercontent.com/944158/63353912-cbce8a00-c363-11e9-9e06-c3856da5410e.png)

![Manage users](https://user-images.githubusercontent.com/944158/63353941-ddb02d00-c363-11e9-94ee-1411ae102645.png)

## Features

### Confirm Modal

Admin Panel includes a generic confirmation modal for links, out of the box. Using HTML data attributes on `<a>`-tags the modal can be configured in different ways. Just add a data attribute to your link and you're all set.

Triggering the modal will append a HTML-element form to the DOM, containing title, text, confirm button and dismiss button.

By default confirm submits the form and dismiss will remove the HTML-element from the DOM

**Basic usage**

```HTML
<a href="#" data-confirm="true">Open modal</a>
```

**Data Attributes**

|Attribute|Description|example|
|---------|-----------|-------|
|data-confirm|Initialize the modal|`data-confirm="true"`|
|data-title|Sets the title of the modal|`data-title="Please confirm"`|
|data-text|Sets the text of the modal|`data-text="Are you sure you want to continue?"`|
|data-button|Sets bootstrap css selector for the confirm button|`data-button="danger"` _[primary,secondary,success,danger,warning,info,light,dark]_|
|data-confirm-btn|Set the text label on the "confirm"-button|`data-confirm-btn="Yes"`|
|data-dismiss-btn|Set the text label on the "dismiss"-button|`data-confirm-btn="No"`|

**Override default behavior**

```javascript
// Override modal confirm action
modalConfirmation.actions.confirm = function(event) {
    alert("Confirmed");
}

// Overríde modal dismiss action
modalConfirmation.actions.dismiss = function(event) {
    alert("Dismissed");
}
```

### Leaf tags

Admin panel comes with a variety of leaf tags for generating certain HTML/js elements

#### #adminPanelAvatarURL
Use user image or fallback to [Adorable avatars](http://avatars.adorable.io/)

|Parameter|Type|Description|
|---------|----|-----------|
|`email`|String| _user's email_|
|`url`|String|_image url_|

Example usage
```html
<img src="#adminPanelAvatarURL(user.email, user.avatarURL)" alt="Profile picture" class="img-thumbnail" width="40">
```

#### #adminPanelConfig
Convenience method to output configuration strings such as app or environment name or paths to certain templates

Supported input values and what they output

 - `name`: App name
 - `baseURL`: App base URL
 - `sidebarMenuPath`: Path to sidebar menu view template
 - `dashboardPath`: Path to dashboard view template
 - `environment`: Environment name

|Parameter|Type|Description|
|---------|----|-----------|
|`configName`|String| _Config variable name_|

Example usage
```html
<!-- outputs app name -->
#adminPanelConfig("name")
```

#### #adminPanel:user
Outputs a field on the current user object as a string

|Parameter|Type|Description|
|---------|----|-----------|
|`fieldName`|String| _User field name_|

Example usage
```html
<!-- outputs user's name -->
#adminPanelUser("name")
```

#### #adminPanel:user:hasRequiredRole
Check if user has a required role

|Parameter|Type|Description|
|---------|----|-----------|
|`roleName`|String| _User role_|

Example usage
```
#if(adminPanelUserHasRequiredRole("superAdmin")):
    // Do something
#else:
    // Do something else
#endif
```

#### #adminPanelSidebarHeading
Renders a header, styled in a certain way, for the navigation sidebar.

Example usage
```
#adminPanelSidebarHeading: 
    Super Admin
#endadminPanelSidebarHeading
```
Renders
```html
<h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
    <span>Super Admin</span>
</h6>
```

#### #adminPanelSidebarMenuItem
Renders a sidebar menu item, styled in a certain way, for the navigation sidebar.

|Parameter|Type|Description|
|---------|----|-----------|
|`url`|String| _Menu item link reference_|
|`icon`|String| _Feather icon for menu item_|
|`activeURLPatterns`|String| _URL pattern to determine active state_|

Example usage
```
#adminPanelSidebarMenuItem("/admin/dashboard", "home", "/admin/dashboard*"):
    Home 
#endadminPanelSidebarMenuItem
```
Renders
```html
<li class="nav-item">
    <a class="nav-link" href="/admin/dashboard">
        <span data-feather="home"></span>
        Home
    </a>
</li>
```
