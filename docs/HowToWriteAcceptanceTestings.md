# How To Write Acceptance Testings

- [ ] Define a a template or/and examples to write **Acceptance Tests** 

- General
- Start using the word **should**
- written from the user perspective
- write assuming of a running, functioning system with no data

- Four kinds of specs

1. Executable Specifications
  - Focus on WHAT and not on HOW e.g. “placeAnOrder” or “payByCreditCard"

2. Domain Specific Language (DSL):
  - A common language to reuse concepts like ‘placeAnOrder’, ’bill’, ’ticket’

3. Protocol Drivers.
  - Translate to more specific steps, but still in an final user perspective
    e.g. "get in the URL", "fill X form", etc
