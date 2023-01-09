## Programming

### Python Default installation
```bash
sudo apt update && sudo apt install -y python3 python3-pip python3-dev python3-venv
```

### Venv management
```bash
python3 -m venv virtualenv
source virtualenv/bin/activate
deactivate
```

### Git branching strategies

Modern teams use different Git branching strategies depending on how often they release, how many versions they support, and how strict their review and testing process needs to be. This document introduces three common approaches: Git Flow, GitHub Flow, and Trunk-based development, compares how each one organizes long- and short-lived branches, handles hotfixes and releases, and balances speed versus control. The goal is to highlight when each workflow works best, along with the trade-offs in complexity, overhead, and reliability.

### Git Flow

```
                                 v1.0 | v1.1       
main   ───┬──────────────────────────────────────►
          │     ▲         ▲           ▲           
          │     │ hotfix2 │           │           
 hotfix 1 └─────┤    ┌────┤           │ release    
                │    │    │           │            
                ▼    │    ▼           │            
dev    ─────┬──┬─────┴───┬────────────┴──────────►
            │  │    ▲    │  ▲     ▲               
            │  └──X─┘    └─X┘     │               
            │ small features      │               
    new big │                     │               
    feature │                     │               
            └──────────X──────X───┘               
rebases to include small features and hotfixes (X)  
```

- Long-term branches: `main` and `dev`
    - Each long-term branch points to one different environment
- Short-term branches for hotfixes: `hotfix 1` and `hotfix2`
- Other branches for features parallel to dev: `new big feature` and `small features`
- Release branches to update `main` with code from `dev`
- Rebases (X) to include new code from other features and hotfixes
- Useful for software distributed in different versions and for support multiple versions
- Useful to desktop, mobile and enterprise applications
- Much overhead to manage branches
- Strongly aligned with the review process using pull requests

### GitHub Flow

```
                  Deployable versions                 
                    ▼       ▼     ▼             
main   ─────┬──┬─────────┬─────────────────────► 
            │  │    ▲    │  ▲     ▲             
    new big │  └────┘    └──┘     │             
    feature │ small features or   │             
    or new  │ hotfixes            │             
    hotfix  │                     │             
            └──────────X──────X───┘             
rebases to include small features and hot fixies
```

- One long-term branch: `main`
- Each update can be deployable after a new PR and review process
- Other environments must have different deployment strategies, if they are needed
- Almost always aligned to a strong test pipeline included in the process
- Useful for software as a service or changes have to move fast without management overhead
- Useful to web apps or pages with many updates and no reason to use old versions
- Harder to roll back to an older version

### Trunk-based development

```
main   ───┬──┬──┬──┬──┬──┬──┬────┬─────┬──────────►
          │▲ │▲ │▲ │▲ │▲ │▲ │▲   │     │           
          └┘ └┘ └┘ └┘ └┘ └┘ └┘   ▼     ▼           
small frequent commits directly tests  enable      
inside main branch from many           feature     
different developers                   flags       
```

- One long-term branch: `main`
- Developers include smallest changes directly on main without PR or review (only automated tests)
- All development is based on **feature flags**
- At certain point, all software is tested (new disabled features included)
- After tests, the correct feature flags are enabled and the software is available for users in production
- Useful for experienced teams with complete known of feature flag best practices
- Useful to small projects or at the beginning of a MVP
- Fastest approach with shortest development cycle

- Requires a complex pipeline and a extra commitment to testing
- It does not include reviews and this can be a problem in many cases
