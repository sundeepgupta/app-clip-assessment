## Setup
- Build with Xcode 26.2 (older versions may work).
- Select the `ReactivAppClip` scheme.
- To launch with an invocation URL, set `_XCAppClipURL` under Run → Arguments → Environment Variables.

## Scope

### Implemented
- Core App Clip flows: product list (2-column grid), product detail, and cart.
- Asynchronous product fetch from the provided JSON endpoint.
- Asynchronous image loading with lightweight placeholders.
- In-memory, session-scoped cart state.
- Targeted unit tests for URL parsing, cart logic, product controller and repository.

### Intentionally Not Implemented (Out of Scope)
- Persistence across App Clip launches.
- App Clip ↔ full app state sharing.
- Local notifications and App Clip notification configuration.

### Not Implemented Yet (Next Iteration)
- Invocation URL handling for `/collections/all`.
- User-facing fallback UI for invalid or unknown product handles.
- Local notification handling.
- Product variant support.

## Thought Process
- Reduced risk early by validating unknowns (notably SwiftUI navigation and invocation-driven routing) before locking in structure.
- Optimized for App Clip constraints by treating the experience as invocation-driven and session-oriented rather than long-lived.

## Architecture Decisions
- Intentionally minimal architecture to avoid premature abstraction.
- Three logical layers: View, Controller (aka ViewModel), and Repository.
- Centralized, deterministic invocation URL routing with a safe fallback to the product list.
- Cart state shared across relevant views and scoped entirely in memory.
- With additional scope or longevity, clearer boundaries would be introduced for networking, persistence, navigation, and dependency management.

## Trade-offs and Limitations
- No caching or request coalescing for product data; list and detail screens may fetch independently in favor of simplicity.
- Cart state is ephemeral; termination requires re-adding items, consistent with App Clip lifecycle expectations.
- Monetary values use `Float`; sufficient for the exercise but not production-grade.

## Weakest Area
- Product detail UX lacks a direct cart entry point.
- No visual feedback when items are added to or already present in the cart.
- Loading and error states are not yet surfaced.

## Use of AI
- Used ChatGPT and Codex as a collaborator, reviewer, and accelerator.
- Identify constraints, validate decisions, and evaluate trade-offs.
- Improve README structure and clarity.

## Time Spent
- 8–9 hours
