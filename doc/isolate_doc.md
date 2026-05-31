# Dart Isolates - Complete Guide

## Architecture Overview

This diagram illustrates the relationship between the **Main Thread**, **Event Loop**, **Queues**, and **Worker Threads (Isolates)**.

```text
┌─────────────────────────────────────────────────────────────┐
│                      Main Thread                             │
│                   (UI + Event Loop)                          │
│                                                              │
│                    ┌──────────────┐                         │
│                    │  Event Loop  │◄─────────────────┐      │
│                    └──────┬───────┘                  │      │
│                           │                          │      │
│              ┌────────────┴────────────┐            │      │
│              │                         │             │      │
│      ┌───────▼────────┐      ┌────────▼──────┐     │      │
│      │ Microtask Queue│      │  Event Queue   │     │      │
│      │    (Higher     │      │   (Lower       │     │      │
│      │    Priority)   │      │   Priority)    │     │      │
│      └────────────────┘      └────────────────┘     │      │
└─────────────────────────────────────────────────────┼──────┘
                                                       │
                                                       │
┌──────────────────────────────────────────────────────┼──────┐
│              Worker Threads (Isolates)               │      │
│                                                      │      │
│  ┌─────────────────────────────────────┐                │      │
│  │  Separate Port Worker Thread    │                │      │
│  │        (Isolate 1)               │                │      │
│  └─────────────────────────────────┘                │      │
│                                                      │      │
│  ┌─────────────────────────────────┐                │      │
│  │  Separate Port Worker Thread    │                │      │
│  │        (Isolate 2)               │────────────────┘      │
│  └─────────────────────────────────┘                       │
│                                                             │
│        Communication via SendPort/ReceivePort               │
└─────────────────────────────────────────────────────────────┘
```

## Components Explanation

### 🟥 Main Thread

- Contains the **UI** and **Event Loop**
- Handles user interface operations and processes events
- Single-threaded execution model

### 🟠 Event Loop

- Responsible for taking tasks from the **Microtask Queue** and **Event Queue**
- Runs them in order based on priority
- Continuously processes events to keep the app responsive

### 🔵 Microtask Queue

- **Higher priority** queue
- Handles urgent tasks like `Future.microtask`, `scheduleMicrotask`
- Processed before Event Queue tasks

### 🟢 Event Queue

- **Lower priority** queue
- Handles regular tasks like:
  - `Future.delayed`
  - I/O events
  - Timers
  - User input events

### 🟣 Worker Threads (Isolates)

- Each **Isolate** has its own **separate memory**
- Runs independently and communicates with Main Thread via **SendPort/ReceivePort**
- Does **not share memory** with Main Thread
- Perfect for heavy computations without blocking UI

## Key Concepts

### Event Loop Priority

1. **Microtask Queue** runs first (highest priority)
2. **Event Queue** runs after microtask queue is empty
3. Process repeats continuously

### Isolate Communication

- **SendPort**: Sends messages TO an isolate
- **ReceivePort**: Receives messages FROM an isolate
- Communication is **message-based** (no shared memory)
- Messages are **copied** between isolates

## Why Use Isolates?

| Without Isolates | With Isolates |
|------------------|---------------|
| Heavy tasks block UI | UI stays responsive |
| Single thread processes everything | Parallel processing |
| App freezes during computation | Smooth user experience |

## Example Flow

```dart
Main Thread                          Isolate
     │                                  │
     ├─ Create ReceivePort              │
     ├─ Spawn Isolate ──────────────►  │
     │                                  ├─ Start heavy work
     │                                  ├─ Calculate...
     │                                  ├─ Calculate...
     ├─ UI stays responsive!            │
     │                                  ├─ Done!
     │  ◄────── Send result via SP ─────┤
     ├─ Receive result                  │
     ├─ Update UI                       │
     └─ Close ports/Kill isolate        └─ Terminated
```

## Summary

- **Main Thread** handles UI and event processing
- **Event Loop** processes tasks from two queues (Microtask > Event)
- **Isolates** run separately with their own memory
- **Communication** happens via ports (SendPort/ReceivePort)
- **No shared memory** between isolates (prevents race conditions)
