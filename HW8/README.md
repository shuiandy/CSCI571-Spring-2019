# HW8 - eBay Search Application

## XSS Security Fix

### Problem
The application had a Cross-Site Scripting (XSS) vulnerability in the `show-detail.component.ts` file where user data from eBay API was directly concatenated into HTML strings and inserted into the DOM using `innerHTML`. This could allow malicious scripts to be executed if the API returned data containing script tags.

### Solution
1. **Removed direct DOM manipulation**: Eliminated the use of `document.getElementById('table').innerHTML = htmltext;`
2. **Implemented Angular data binding**: Created a `detailItems` array to store structured data
3. **Used Angular template interpolation**: Replaced HTML string concatenation with Angular's safe `{{}}` interpolation
4. **Automatic HTML escaping**: Angular's interpolation automatically escapes HTML content, preventing XSS attacks

### Files Modified
- `src/app/show-detail/show-detail.component.ts`: Removed unsafe DOM manipulation, added structured data approach
- `src/app/show-detail/show-detail.component.html`: Updated template to use Angular data binding

### Security Benefits
- **Automatic HTML escaping**: Angular's interpolation prevents script injection
- **No direct DOM manipulation**: Eliminates the risk of XSS through innerHTML
- **Type safety**: Structured data approach provides better type checking
- **Maintainability**: Cleaner, more readable code that follows Angular best practices

## Original README Content

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 7.3.7.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).
