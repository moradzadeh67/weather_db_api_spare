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

## 5. Language Display Rules (RTL Formatting)

To ensure correct right-to-left (RTL) display in the chat interface:
- [ ] **Strict Language Separation**: Each line must contain words from ONLY ONE language (either Persian or English).
- [ ] **English in Persian Text**: When a Persian response contains English words, paths, or code symbols, move the English content to a NEW LINE using a double line break.
- [ ] **Resume Persian**: After the English line, resume the Persian text on another NEW LINE.
- [ ] **Code Blocks Exception**: This rule does NOT apply to code blocks. All code must remain in a single code block, and Persian explanations related to specific lines should be added as comments within that same line of code.
- [ ] **Consistency**: This rule applies to all responses, summaries, and walkthroughs.

## Security & Public Repository Rules
- [ ] **No Unauthorized Pushes**: NEVER push code to GitHub, GitLab, or any remote repository without explicit permission from the user.
## Security & Public Repository Rules
- [ ] **No Unauthorized Pushes**: NEVER push code to GitHub, GitLab, or any remote repository without explicit permission from the user.
- **Never commit sensitive data** (API keys, passwords, tokens, `.env` files, or any credentials) to the repository.
- This project will be published as a **public repository**, so all secrets must be stored externally and explicitly ignored by Git via `.gitignore`.
- Use clear placeholders like `YOUR_API_KEY_HERE` in code and configuration templates.
- Always verify `.gitignore` is correctly configured before the first push. If a secret is accidentally committed, revoke it immediately and clean the Git history.

## 6. Task Execution Protocol (Approval Workflow)

To ensure the user is always informed and in control of project changes:
- [ ] **Plan First**: Before modifying any code or project settings, the Agent must provide a detailed explanation of the proposed changes.
- [ ] **Explicit Approval**: The Agent must WAIT for explicit user approval (e.g., "Proceed", "Approved", or clicking the Proceed button) before starting execution.
- [ ] **Change Impact**: The explanation must include which files will be affected and what the impact on the app's behavior will be.
- [ ] **No Guessing**: If a request is ambiguous, the Agent must ask for clarification instead of making assumptions that lead to code changes.

---

**Status:** SSD / SPARC Guide — Weather (`Weather`) Project with Flutter  
**Source:** `SPARC_Weather_Guide_Junior.pdf`
