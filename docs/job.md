flowchart LR;
    sleeping -->|run|running;
    running -->|clean|cleaning;
    running -->|sleep|sleeping;
    cleaning -->|sleep|sleeping;
