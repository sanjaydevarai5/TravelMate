# Sprint 3 manual test plan

| Test | Steps | Expected |
| --- | --- | --- |
| Home | Open / | Responsive Pug homepage |
| Database-backed list | Open /trips | Trip from MySQL appears |
| Details | Open /trips/1 | Six days, activities, estimated costs |
| Missing record | Open /trips/99999 | 404 response |
| Bad ID | Open /trips/not-a-number | 400 response |
| Health | Open /health | JSON status ok |
| Dynamic data | Change sample trip title in MySQL, refresh /trips | Updated title appears |
| Responsive | Resize browser to mobile width | No horizontal overflow |
| Restart | Restart app container without deleting MySQL volume | Data remains |

Capture genuine screenshots and terminal logs. Mark tests passed only after running them. Team members should commit their own review/fixes for academic contribution evidence.
