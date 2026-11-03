# Sprint 2 — Reference-aligned design clarification

Source: seven PDFs supplied by the team on 3 November 2026, including Emma Bennett and Sophie Chen customer journeys, two sequence diagrams, use-case diagram, TourPlan state diagram and conceptual class diagram.

## Essential workflow
1. Human travel agent Sophie Chen creates Emma Bennett's six-day Tokyo/Kyoto proposal as **Draft**.
2. Agent adds day-by-day places, activities, notes, indicative flight/cost estimates and manually checked public video links.
3. Agent previews and shares it (**Shared**).
4. Traveller Emma Bennett reviews and may request changes.
5. A substantive revision returns the proposal to **Draft**; previous confirmation is invalidated. Agent re-shares for fresh review.
6. Emma **explicitly confirms the current proposal version**.
7. Sophie, the **human agent**, verifies that confirmation and marks **Approved**. Emma's click must never automatically approve the plan.

**Approval is not booking.** No live flight fares, payments, actual reservations or autonomous AI are included.

## Reference mapping
- Emma journey: US10–US12, US14–US15
- Sophie journey: US03–US09, US13–US14
- Create/share sequence: US04–US09
- Review/revise/approve sequence: US05, US12–US14
- Use-case diagram: all agent/traveller features
- TourPlan state diagram: US04–US05, US09, US14, US16
- Conceptual class diagram: US04, US06–US08, US14

## Model refinements requiring team review
The source state diagram explicitly labels deletion from any persistent state and Approved-to-Draft substantive revision as **proposed refinements**. Do not present them as already implemented or settled policy.

## GitHub issues
See #20–#40 for the Sprint 2 stories and assigned design tasks. In particular, #24, #31, #33 and #35 were revised to align with the references.

## Submission evidence
The PDF report combines complete story/acceptance-criteria descriptions, wireframe specifications and all seven source diagram pages. GitHub Project board membership/status, screenshot, team sign-off and Moodle receipt remain unverified.
