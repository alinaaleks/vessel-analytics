# Cleaning that goes behind the scenes

Today I decided to document for my future review.

## Data Cleaning & Model Refactor Log (Excel → SQL)

### 1. Core structural shift

- Moved from Excel sheets → relational database design
- Introduced clear separation:
  - Master data
  - Business contracts
  - Allocations
  - Financial transactions
  - Reporting layers

---

### 2. Core entities

- **projects** (top-level grouping of vessels)
- **vessels** (now belong to projects)
- **counterparts** (companies with INN)
- **contracts** (all commercial agreements unified into one table)
- **payments** (financial transactions)

---

### 3. Relationship / bridge tables

- **vessel_allocation** (to allocate quantities for each vessel)
  - replaces Excel “contracts_by_pjs”
  - handles allocation of quantities from contracts → vessels

---

### 4. Contract model redesign

- Unified all contract types into one table:
  - farmer contracts
  - transport contracts
  - agent contracts
  - lab contracts
  - buyer contracts
  - vessel operational contracts

- Added:
  - `contract_type` (classification)
  - `contract_group_id` (logical grouping of related contracts)

---

### 5. Contract grouping logic

- **contract_groups**
  - used to link related contracts (farmer + transport + agent + lab)
  - NOT used for calculations, only traceability

---

### 6. Vessel & project relationship

- Each **vessel belongs to exactly one project**
- Project can contain multiple vessels
- Project is a **grouping/reporting layer**, not a primary dependency for all tables
- Main concept in project analytics logic - define relationship to vessel

---

### 7. Cost model

- Separation of cost types:

#### Quantity-based costs

- used for farmer → vessel allocation logic

#### Fixed / operational costs

- lab
- agent
- expeditor
- surveyor
- losses / failed contracts

---

### 8. Key modeling correction

- Project is NOT stored everywhere

- Project is derived via:
  - vessel → project relationship

- Removed idea of duplicating project_id in:
  - contracts
  - payments
  - operational tables

---

### Analytics goal preserved

System should support:

- vessel profitability
- project profitability
- contract profitability
- cost breakdown by type
- time-based payment analysis

---
