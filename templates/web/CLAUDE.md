# Web Application Project Instructions

This is a web application project. Follow these specific guidelines when working with this codebase.

## Project Detection
Detect framework from package.json dependencies:
- React: "react" in dependencies
- Vue: "vue" in dependencies
- Angular: "@angular/core" in dependencies
- Next.js: "next" in dependencies
- Nuxt: "nuxt" in dependencies

## Common Project Structure
```
├── src/                    # Source code
│   ├── components/        # Reusable components
│   ├── pages/            # Page components/routes
│   ├── services/         # API and business logic
│   ├── utils/            # Utility functions
│   ├── hooks/            # Custom hooks (React)
│   ├── stores/           # State management
│   ├── styles/           # Global styles
│   └── assets/           # Static assets
├── public/               # Public static files
├── tests/                # Test files
├── dist/build/out/       # Build output
└── package.json          # Dependencies and scripts
```

## Framework-Specific Guidelines

### React/Next.js
```typescript
// Component Template
import React, { useState, useEffect } from 'react';
import styles from './Component.module.css';

interface ComponentProps {
  title: string;
  onAction?: () => void;
}

const Component: React.FC<ComponentProps> = ({ title, onAction }) => {
  const [state, setState] = useState<string>('');

  useEffect(() => {
    // Side effects
    return () => {
      // Cleanup
    };
  }, []);

  return (
    <div className={styles.container}>
      <h1>{title}</h1>
    </div>
  );
};

export default Component;

// Custom Hook
export const useCustomHook = (initialValue: any) => {
  const [value, setValue] = useState(initialValue);
  
  const updateValue = (newValue: any) => {
    setValue(newValue);
  };
  
  return [value, updateValue] as const;
};
```

### Vue 3/Nuxt 3
```vue
<!-- Component Template -->
<template>
  <div class="component">
    <h1>{{ title }}</h1>
    <button @click="handleClick">{{ buttonText }}</button>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';

interface Props {
  title: string;
  initialValue?: number;
}

const props = withDefaults(defineProps<Props>(), {
  initialValue: 0
});

const emit = defineEmits<{
  update: [value: number];
}>();

const counter = ref(props.initialValue);

const buttonText = computed(() => `Count: ${counter.value}`);

const handleClick = () => {
  counter.value++;
  emit('update', counter.value);
};

onMounted(() => {
  // Component mounted
});

onUnmounted(() => {
  // Cleanup
});
</script>

<style scoped>
.component {
  padding: 1rem;
}
</style>
```

### Angular
```typescript
// Component Template
import { Component, OnInit, OnDestroy, Input, Output, EventEmitter } from '@angular/core';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-example',
  templateUrl: './example.component.html',
  styleUrls: ['./example.component.scss']
})
export class ExampleComponent implements OnInit, OnDestroy {
  @Input() title: string = '';
  @Output() action = new EventEmitter<string>();
  
  private subscriptions = new Subscription();
  
  constructor(private service: ExampleService) {}
  
  ngOnInit(): void {
    // Initialization
  }
  
  ngOnDestroy(): void {
    this.subscriptions.unsubscribe();
  }
  
  handleAction(): void {
    this.action.emit('data');
  }
}
```

## State Management

### Redux/RTK (React)
```typescript
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface State {
  value: number;
}

const initialState: State = {
  value: 0
};

const slice = createSlice({
  name: 'counter',
  initialState,
  reducers: {
    increment: (state) => {
      state.value += 1;
    },
    setValue: (state, action: PayloadAction<number>) => {
      state.value = action.payload;
    }
  }
});

export const { increment, setValue } = slice.actions;
export default slice.reducer;
```

### Pinia (Vue)
```typescript
import { defineStore } from 'pinia';

export const useCounterStore = defineStore('counter', {
  state: () => ({
    count: 0
  }),
  
  getters: {
    doubleCount: (state) => state.count * 2
  },
  
  actions: {
    increment() {
      this.count++;
    }
  }
});
```

## API Integration

### Axios Configuration
```typescript
import axios from 'axios';

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL || 'https://api.example.com',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Request interceptor
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
  (response) => response.data,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized
    }
    return Promise.reject(error);
  }
);

export default api;
```

## Performance Optimization

### Code Splitting
```typescript
// React lazy loading
const LazyComponent = React.lazy(() => import('./LazyComponent'));

// Vue async component
const AsyncComponent = defineAsyncComponent(() => import('./AsyncComponent.vue'));

// Dynamic imports
const module = await import('./module');
```

### Optimization Techniques
- Use React.memo() / Vue computed properties
- Implement virtual scrolling for long lists
- Lazy load images and components
- Minimize bundle size with tree shaking
- Use production builds
- Enable gzip/brotli compression
- Implement service workers for caching

## Testing

### Unit Testing (Jest/Vitest)
```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import Component from './Component';

describe('Component', () => {
  it('should render correctly', () => {
    render(<Component title="Test" />);
    expect(screen.getByText('Test')).toBeInTheDocument();
  });
  
  it('should handle click', () => {
    const handleClick = jest.fn();
    render(<Component onClick={handleClick} />);
    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

### E2E Testing (Cypress/Playwright)
```typescript
// Cypress example
describe('App E2E', () => {
  it('should navigate to page', () => {
    cy.visit('/');
    cy.contains('Welcome').should('be.visible');
    cy.get('[data-testid="button"]').click();
    cy.url().should('include', '/dashboard');
  });
});
```

## Build & Deploy

### Common Scripts
```json
{
  "scripts": {
    "dev": "vite/next dev/npm start",
    "build": "vite build/next build/npm run build",
    "test": "jest/vitest",
    "lint": "eslint src --ext .ts,.tsx",
    "format": "prettier --write \"src/**/*.{ts,tsx,css}\"",
    "typecheck": "tsc --noEmit",
    "preview": "vite preview",
    "analyze": "source-map-explorer 'build/static/js/*.js'"
  }
}
```

### Environment Variables
```bash
# .env.local (Next.js) / .env (Vite)
VITE_API_URL=https://api.example.com
NEXT_PUBLIC_API_URL=https://api.example.com
REACT_APP_API_URL=https://api.example.com
```

## CSS/Styling

### CSS Modules
```css
/* Component.module.css */
.container {
  padding: 1rem;
}

.title {
  font-size: 2rem;
  color: var(--primary-color);
}
```

### Tailwind CSS
```jsx
<div className="p-4 bg-white dark:bg-gray-800 rounded-lg shadow-md">
  <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
    Title
  </h1>
</div>
```

### Styled Components
```typescript
import styled from 'styled-components';

const Container = styled.div`
  padding: 1rem;
  background: ${props => props.theme.background};
`;

const Title = styled.h1`
  font-size: 2rem;
  color: ${props => props.theme.primary};
`;
```

## Security Best Practices

1. **Input Validation**
   - Sanitize user inputs
   - Use validation libraries (Joi, Yup, Zod)
   - Implement CSRF protection

2. **XSS Prevention**
   - Use framework sanitization
   - Avoid dangerouslySetInnerHTML
   - Escape user content

3. **Authentication**
   - Use HTTPS only
   - Implement JWT properly
   - Store tokens securely
   - Add refresh token rotation

4. **Dependencies**
   - Keep dependencies updated
   - Run security audits regularly
   - Use lock files

## Performance Metrics

Target metrics:
- First Contentful Paint (FCP): < 1.8s
- Largest Contentful Paint (LCP): < 2.5s
- Cumulative Layout Shift (CLS): < 0.1
- Time to Interactive (TTI): < 3.8s
- Bundle size: < 200KB (gzipped)

## Debugging

### Browser DevTools
- Use React/Vue DevTools extensions
- Check Network tab for API calls
- Profile with Performance tab
- Debug with Sources tab

### Console Helpers
```typescript
// Conditional logging
if (process.env.NODE_ENV === 'development') {
  console.log('Debug info:', data);
}

// Performance timing
console.time('operation');
// ... code ...
console.timeEnd('operation');

// Table display
console.table(arrayOfObjects);
```

## Accessibility (a11y)

- Use semantic HTML
- Add ARIA labels where needed
- Ensure keyboard navigation
- Maintain focus management
- Test with screen readers
- Provide alt text for images
- Use sufficient color contrast

## Common Commands
```bash
# Development
npm run dev / yarn dev / pnpm dev

# Build
npm run build / yarn build / pnpm build

# Test
npm test / yarn test / pnpm test

# Lint & Format
npm run lint / yarn lint
npm run format / yarn format

# Type Check
npm run typecheck / yarn typecheck

# Bundle Analysis
npm run analyze / yarn analyze

# Clean Install
rm -rf node_modules package-lock.json && npm install
```

## Git Workflow
- Create feature branches from develop/main
- Use conventional commits
- Run tests before committing
- Keep PRs focused and small
- Update documentation with changes