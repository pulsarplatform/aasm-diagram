flowchart LR;
    standing -->|walk|walking;
    standing -->|run|running;
    walking -->|run|running;
    walking -->|hold|standing;
    running -->|hold|standing;
