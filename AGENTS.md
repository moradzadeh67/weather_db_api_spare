---
name: ssd-spare-weather-agent-rules
scope: project
language: en
---

# SSD / SPARC Project Execution Rules (Agent Guide)

Left-aligned / English active per user request ✅

These rules are extracted from the `SPARC_Weather_Guide_Junior.pdf` guide for agent-driven project execution using the **SSD (Specification-Driven Development)** / SPARC method.

---

## 1. Main Project Stages (SSD / SPARC)

### Stage 1: Project Setup (`Project Setup`)
- Create a new project with a defined name
- Add required dependencies in `pubspec.yaml`
- Define folder structure (`models`, `services`, `pages`)

### Stage 2: Data Model Design (`Data Model`)
- Build the `Model` class for API data
- Define required fields (name, description, numeric values, etc.)
- Implement `fromJson` and `toJson` methods

### Stage 3: Storage Service (`Storage Service`)
- Design the local storage service (`Local Storage`)
- Store data when there is no internet (`Offline Fallback`)
- Retrieve cached data when needed

### Stage 4: API Service (`API Service`)
- Define base URL (`Base URL`)
- Send request (`Request`)
- Convert response (`Response`) to model (`Model`)
- Handle errors (`Error Handling`)
- Check data existence (`Data Existence Check`)

### Stage 5: State Management (`State Management`)
- Separate business logic (`Business Logic`) from UI
- Manage data received from API
- Manage stored (cached) data
- Choose appropriate state management method (`Provider`, `Bloc`, etc.)

### Stage 6: UI Pages (`UI Pages`)
- Connect widgets to data service
- Show data on main page
- Show details (`Detail View`)
- Show error messages (`Error Message`)
- Show cached data (`Cached Data Display`)

---

## 2. Agent Execution Checklist

Before final delivery, the agent must verify the following:

| # | Check | Status |
|---|---|---|
| 1 | Has the project/package been created? | [ ] |
| 2 | Have dependencies been added to `pubspec.yaml`? | [ ] |
| 3 | Has the data `Model` been built? | [ ] |
| 4 | Has the storage service (`Storage Service`) been written? | [ ] |
| 5 | Is the API service (`API Service`) simple and without business logic? | [ ] |
| 6 | Is data selected and fetched from the API? | [ ] |
| 7 | Has the UI been built with appropriate widgets? | [ ] |
| 8 | Is new data fetched from the internet? | [ ] |
| 9 | Does local storage (`Local Storage`) exist? | [ ] |
| 10 | Is the project free of extra dependencies (`Clean Dependencies`)? | [ ] |

---

## 3. Key SSD Rules for the Agent

### Structure Rules
- [ ] **Only add necessary files** — extra dependencies forbidden (`Clean`)
- [ ] **Data model must be built before service**
- [ ] **API service must be simple** — without business logic
- [ ] **Business logic must be separated from UI** (`State Management` separate)
- [ ] **Page must receive data from the service** — not directly from API

### Data Rules
- [ ] **If data exists in API, use it**
- [ ] **If no internet, show cached/stored data**
- [ ] **If no data in API or storage, show appropriate message**
- [ ] **New data must always be fetched from the internet** (with connectivity check)

### Quality Rules
- [ ] **Project must not become oversized** — only what is needed
- [ ] **Code must be readable with correct naming**
- [ ] **Errors must be handled** (`Error Handling`)
- [ ] **UI must be responsive** (`Responsive UI`)

---

## 4. Final Notes (`Notes`)

- This guide is suitable for simple (`Junior`) projects with Flutter and `Node.js`.
- For larger (`Senior`) projects, additional stages (`Testing`, `CI/CD`) must be considered.
- Always review the checklist before execution.

## Security & Public Repository Rules
- **Never commit sensitive data** (API keys, passwords, tokens, `.env` files, or any credentials) to the repository.
- This project will be published as a **public repository**, so all secrets must be stored externally and explicitly ignored by Git via `.gitignore`.
- Use clear placeholders like `YOUR_API_KEY_HERE` in code and configuration templates.
- Always verify `.gitignore` is correctly configured before the first push. If a secret is accidentally committed, revoke it immediately and clean the Git history.

---

**Status:** SSD / SPARC Guide — Weather (`Weather`) Project with Flutter  
**Source:** `SPARC_Weather_Guide_Junior.pdf`
