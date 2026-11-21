# PRD: KOSGUARD --- Shared-Space Belongings Protection & Incident Management System

**Document status:** Draft for implementation planning\
**Product type:** Mobile application (Android/iOS) with REST API and
property-owner dashboard\
**Target users:** Boarding-house residents and property owners/managers\
**Working tagline:** Know the Owner. Track the Incident. Protect Shared
Spaces.

------------------------------------------------------------------------

## 1. Introduction / Overview

KOSGUARD is a shared-space belongings registry and incident-management
application for boarding houses. It helps residents document personal
belongings placed in communal facilities, view active items in shared
spaces, report missing or exchanged belongings, submit ownership claims,
and follow the handling of incidents.

The initial product focuses on two facilities observed to create
recurring coordination problems:

1.  **Communal laundry/drying area:** clothes can be moved for
    safekeeping, accidentally exchanged, or go missing.
2.  **Shared chiller:** residents' food can be taken or removed without
    the owner's permission, even when ownership labels are present.

Existing WhatsApp groups are useful for communication, but reports can
be difficult to follow through when responsibility is unclear. KOSGUARD
adds structured item identity, time-stamped activity records, incident
reports, claim verification, and a property-owner dashboard. It is
intended to support cooperation between residents and property
management rather than replace communication or management judgment.

KOSGUARD does **not** automatically detect theft or identify a person
who took an item. It records information supplied by users and system
status changes so that residents and property managers can review events
and handle incidents more consistently.

### Product principles

-   One physical item has one permanent digital item record.
-   Ownership is linked to a user account, not only to a room.
-   Residents can see active items in shared facilities, while private
    owner information remains restricted.
-   A room has one permanent QR entry point; individual belongings do
    not need physical QR stickers.
-   Meaningful status changes are logged automatically. Residents do not
    write manual activity logs.
-   Expiration is an operational facility policy, not proof of loss,
    theft, or food-safety status.
-   Residents and property managers share responsibility for keeping
    records and resolving incidents.

------------------------------------------------------------------------

## 2. Goals

### Product goals

-   Provide a central registry for individual belongings currently
    placed in shared laundry/drying areas or shared chillers.
-   Allow residents to identify their own registered items and review
    their item history.
-   Give residents a shared view of active items in communal facilities
    without exposing private owner contact details.
-   Provide structured reporting for missing, exchanged/misplaced, and
    found items.
-   Support ownership claims and property-manager-assisted verification.
-   Give property owners/managers a dashboard to monitor active items,
    incidents, claims, and important activity.
-   Automatically expire facility-use sessions according to configurable
    policies and notify relevant users.
-   Improve traceability and follow-up compared with relying solely on
    unstructured group messages.

### Initial measurable objectives

The following are proposed MVP targets to validate during pilot testing,
not existing performance claims:

-   A resident can register an item using a photo and category with no
    more than a few required fields.
-   A resident can report a missing, exchanged, or found item without
    contacting a manager first.
-   Every supported item status change creates a timestamped
    activity-log entry.
-   Expired sessions are reflected in the system and surfaced to the
    item owner and property owner.
-   A property owner can locate an incident and review its current
    handling status from the dashboard.
-   Private owner contact details are not exposed in the shared
    inventory.
-   The system prevents more than one active facility-use session for
    the same item at a time.

------------------------------------------------------------------------

## 3. User Stories

### Epic A --- Accounts, properties, rooms, and access

#### US-001: Register and authenticate an account

**Description:** As a resident or property owner, I want to create an
account and sign in so that my items and actions are associated with my
identity.

**Acceptance Criteria:** - \[ \] Users can register and sign in using
the authentication method selected for the MVP. - \[ \] Authenticated
API requests identify the current user. - \[ \] Passwords are never
stored in plain text. - \[ \] Users can sign out. - \[ \] Typecheck/lint
passes.

#### US-002: Manage a property and its rooms

**Description:** As a property owner, I want to manage my property and
its rooms so that residents and belongings can be associated with the
correct boarding house.

**Acceptance Criteria:** - \[ \] A property owner can create and update
property information. - \[ \] A property can contain multiple rooms. -
\[ \] A room belongs to exactly one property. - \[ \] Room membership is
stored separately so a room can have multiple residents. - \[ \] Only
authorized property managers can manage their property's rooms and
memberships. - \[ \] Typecheck/lint passes.

#### US-003: Associate multiple residents with one room

**Description:** As a resident, I want my account to be associated with
my room so that my items can be linked to my actual owner account and
room.

**Acceptance Criteria:** - \[ \] A room can have multiple members
through `room_members`. - \[ \] An item has one owner user account. - \[
\] An item can also reference the owner's room context. - \[ \] Removing
a resident from a room does not delete that resident's item history. -
\[ \] Typecheck/lint passes.

#### US-004: Open a room inventory using a room QR code

**Description:** As a resident, I want to scan the permanent QR code
assigned to a room so that I can open the relevant room inventory
quickly.

**Acceptance Criteria:** - \[ \] Each room can have one active permanent
QR identifier. - \[ \] The QR contains a random, non-guessable token
rather than a raw room number or personal information. - \[ \] The
backend resolves the token and checks the user's access before returning
data. - \[ \] A revoked or invalid token does not reveal room or
resident information. - \[ \] Scanning a room QR opens the room's
relevant inventory view. - \[ \] UI is verified on supported mobile
devices.

### Epic B --- Ownership registry and shared inventory

#### US-005: Register an individual belonging

**Description:** As a resident, I want to register each belonging that I
place in a shared facility so that its identity and ownership can be
referenced later.

**Acceptance Criteria:** - \[ \] The registration flow requires a photo
and category. - \[ \] Description, color, brand, and distinctive marks
are optional fields. - \[ \] Every physical object receives a unique
`item_id`. - \[ \] Multiple similar objects are stored as separate item
records. - \[ \] The item is linked to one owner user account. - \[ \]
The item is associated with the appropriate room/property context. - \[
\] Photos are stored in file/object storage; the database stores the
file path or storage key. - \[ \] UI is verified on supported mobile
devices.

#### US-006: View my private ownership log

**Description:** As a resident, I want to see all my registered items
and their histories so that I can review what I own and where I last
recorded it.

**Acceptance Criteria:** - \[ \] A resident can view all items owned by
their account. - \[ \] The view includes current status and relevant
facility-use history. - \[ \] The view includes item activity and
incident references where the user is authorized. - \[ \] A resident
cannot view another resident's private owner log. - \[ \] UI is verified
on supported mobile devices.

#### US-007: View the centralized shared inventory

**Description:** As a resident, I want to view active items in shared
facilities across the property so that I can distinguish registered
belongings from my own.

**Acceptance Criteria:** - \[ \] Residents can view active items
currently registered in shared facilities within their property. - \[ \]
Shared inventory displays item photo, category, limited description, and
room number. - \[ \] Private owner contact details and other private
profile information are not displayed. - \[ \] Inventory can be filtered
by facility and relevant category/status. - \[ \] Expired, retrieved,
and otherwise inactive sessions are not presented as currently active. -
\[ \] UI is verified on supported mobile devices.

#### US-008: View and update an item's details

**Description:** As an item's owner, I want to correct its descriptive
details so that the registry remains useful when an item changes or was
entered incorrectly.

**Acceptance Criteria:** - \[ \] Only the owner or an explicitly
authorized property manager can edit permitted item fields. - \[ \]
Changes to important item details are recorded in the item's history. -
\[ \] The item ID and ownership history are not silently replaced by
editing descriptive fields. - \[ \] UI is verified on supported mobile
devices.

### Epic C --- Facility usage, status, live log, and expiration

#### US-009: Start a facility-use session

**Description:** As a resident, I want to mark my registered item as
placed in a shared facility so that it appears in the shared inventory.

**Acceptance Criteria:** - \[ \] An owner can activate an existing
registered item for a supported facility. - \[ \] A new `item_usage`
session records the item, facility, activation time, expiry time, and
status. - \[ \] The backend rejects a second active session for the same
item. - \[ \] The expiration duration is obtained from the applicable
backend policy. - \[ \] The item appears in shared inventory while its
session is active. - \[ \] UI is verified on supported mobile devices.

#### US-010: End a facility-use session when an item is retrieved

**Description:** As a resident, I want to mark my item as retrieved so
that it no longer appears as currently stored in a shared facility.

**Acceptance Criteria:** - \[ \] The owner can mark an active item-use
session as `RETRIEVED`. - \[ \] The session is no longer counted as
active inventory. - \[ \] The status change creates an activity-log
entry with actor and timestamp. - \[ \] The owner can activate the same
permanent item again in a later session. - \[ \] UI is verified on
supported mobile devices.

#### US-011: Automatically expire an overdue facility-use session

**Description:** As a resident and property owner, I want overdue
facility-use sessions to expire automatically so that old entries do not
remain indefinitely in the active inventory.

**Acceptance Criteria:** - \[ \] The backend calculates `expires_at`
from the active policy when a session starts. - \[ \] Laundry sessions
expire after 48 hours. - \[ \] Chiller items in category `RAW` expire
after 168 hours (7 days). - \[ \] Chiller items in category `INSTANT`
expire after 240 hours (10 days). - \[ \] The user-facing label for
`INSTANT` is "Makanan Instan & Matang". - \[ \] The Laravel Scheduler
processes due sessions and changes their status to `EXPIRED`. - \[ \]
Backend reads also check whether a session is overdue so scheduler
delays do not leave stale sessions appearing active. - \[ \] Expiration
creates a system-authored activity-log entry. - \[ \] Expiration sends a
notification to the item owner and property owner. - \[ \] Expiration
does not delete the item, mark it `MISSING`, declare it stolen, or
declare food unsafe. - \[ \] A resident can mark an expired item as
retrieved or start a new usage session if it remains in the facility. -
\[ \] UI is verified on supported mobile devices.

#### US-012: Review the live item activity log

**Description:** As a resident or property owner, I want to see a
time-ordered log of meaningful item events so that I can understand
status changes without manually writing activity notes.

**Acceptance Criteria:** - \[ \] The system automatically records
supported user-initiated and system-generated status changes. - \[ \]
Each log entry stores the item/session reference, old status, new
status, actor or system identity, and timestamp. - \[ \] The log
identifies the relevant facility/session. - \[ \] Residents can see the
activity history for their own items. - \[ \] Property owners can see
authorized property-level activity. - \[ \] The log records meaningful
events only; it does not create permanent records for every minor screen
interaction. - \[ \] UI is verified on supported mobile devices.

### Epic D --- Incidents, claims, and resolution

#### US-013: Report a missing item

**Description:** As a resident, I want to report my item as missing so
that other residents and the property owner can help review the
incident.

**Acceptance Criteria:** - \[ \] An authorized resident can submit a
missing-item report for an item they own. - \[ \] The report captures
the item, last known facility/location, report time, description, and
optional evidence/photo. - \[ \] The report is labeled `MISSING` or an
equivalent neutral incident type. - \[ \] The system does not label the
incident as confirmed theft without evidence and review. - \[ \] The
property owner receives an incident notification. - \[ \] UI is verified
on supported mobile devices.

#### US-014: Report an exchanged or misplaced item

**Description:** As a resident, I want to report an item that may have
been accidentally exchanged or misplaced so that its owner can be
identified and the item returned.

**Acceptance Criteria:** - \[ \] A resident can submit a `SWAPPED` or
misplaced-item report. - \[ \] The report can include a description,
likely location, and optional photo/evidence. - \[ \] The report is
distinguishable from a missing-item report. - \[ \] The report is
visible to authorized residents and the property owner according to
privacy rules. - \[ \] UI is verified on supported mobile devices.

#### US-015: Report a found item

**Description:** As a resident, I want to report an item I found in a
shared facility so that its owner can be identified and contacted
through the system.

**Acceptance Criteria:** - \[ \] A resident can submit a `FOUND` report
with facility/location, time, description, and optional photo. - \[ \]
The system can associate the found report with an existing item when a
match is selected or verified. - \[ \] The finder is not required to
determine the owner. - \[ \] The property owner can review the found
report. - \[ \] UI is verified on supported mobile devices.

#### US-016: Submit a private ownership claim

**Description:** As a resident, I want to provide private distinguishing
details when claiming an item so that ownership can be checked without
exposing all identifying information publicly.

**Acceptance Criteria:** - \[ \] A resident can submit a claim against
an eligible found or disputed item/report. - \[ \] The claim supports
private details not displayed in the shared inventory. - \[ \] Only
authorized reviewers can access claim details. - \[ \] A claim has a
trackable status such as `PENDING`, `APPROVED`, or `REJECTED`. - \[ \]
UI is verified on supported mobile devices.

#### US-017: Review and verify an ownership claim

**Description:** As a property owner, I want to review ownership claims
so that disputed items can be returned to the appropriate resident.

**Acceptance Criteria:** - \[ \] The property owner can view pending
claims for their property. - \[ \] The reviewer can inspect claim
details and available evidence. - \[ \] The reviewer can approve or
reject a claim and record a resolution note. - \[ \] The claimant is
notified of the decision. - \[ \] The review action is recorded in
incident history. - \[ \] UI is verified on supported dashboard devices.

#### US-018: Track incident handling and resolution

**Description:** As a property owner, I want to update incident handling
status so that residents can see whether a report is awaiting review or
has been resolved.

**Acceptance Criteria:** - \[ \] Incident reports have defined statuses,
including at minimum `OPEN`, `UNDER_REVIEW`, and `RESOLVED`. - \[ \] The
property owner can update incident status and add a handling note. - \[
\] Every important status change creates an incident-history entry with
actor and timestamp. - \[ \] The system preserves the original report
and its evidence. - \[ \] Authorized reporters can view the status of
their reports. - \[ \] UI is verified on supported dashboard and mobile
views.

### Epic E --- Property-owner dashboard and notifications

#### US-019: Monitor the property from an owner dashboard

**Description:** As a property owner, I want a property-level dashboard
so that I can monitor shared inventory, incidents, claims, and recent
activity in one place.

**Acceptance Criteria:** - \[ \] The dashboard shows counts of active
item sessions, expired sessions, open incidents, and pending claims. -
\[ \] The owner can filter inventory and incidents by facility, room,
category/type, and status where applicable. - \[ \] The owner can open a
record to inspect its details and history. - \[ \] The dashboard only
exposes data belonging to properties the owner is authorized to
manage. - \[ \] UI is verified in the supported dashboard environment.

#### US-020: Receive real-time notifications

**Description:** As a resident or property owner, I want to receive
notifications about important events so that I can respond without
continuously checking the application.

**Acceptance Criteria:** - \[ \] Notifications are generated for new
incident reports and important claim/resolution changes. - \[ \] When a
usage session expires, the item owner and property owner receive
notifications. - \[ \] Notifications identify the relevant item or
incident and provide a route to its detail view. - \[ \] The system
avoids repeated notifications for the same unchanged event. - \[ \]
Notification records are stored and delivery is integrated with Firebase
Cloud Messaging. - \[ \] Users can view relevant notification history in
the application.

------------------------------------------------------------------------

## 4. Functional Requirements

### Accounts and property structure

-   **FR-1:** The system must authenticate residents and property
    owners.
-   **FR-2:** The system must support multiple properties, each
    containing multiple rooms.
-   **FR-3:** The system must support multiple residents in one room
    using a `room_members` relationship.
-   **FR-4:** Every item must reference one owner user account; room
    membership alone must not be treated as proof of ownership.
-   **FR-5:** The system must enforce property-level authorization for
    property-owner actions and data access.

### Room QR

-   **FR-6:** The system must generate one permanent QR identifier per
    room.
-   **FR-7:** The QR must contain a random, non-guessable token and must
    not expose raw room numbers or personal details.
-   **FR-8:** The backend must validate the token and the user's
    authorization before returning room-related data.
-   **FR-9:** The system must support revoking and regenerating a room
    QR token.

### Item registry and visibility

-   **FR-10:** The system must store each physical item as an individual
    record with a unique item ID.
-   **FR-11:** The system must require an item photo and category;
    description, color, brand, and distinctive marks are optional.
-   **FR-12:** Each item must be linked to its owner account and
    relevant room/property.
-   **FR-13:** The system must provide a private ownership log to the
    owner.
-   **FR-14:** The system must provide a centralized shared inventory of
    active items in communal facilities within a property.
-   **FR-15:** Shared inventory may show item information and room
    number but must not expose private owner contact information.
-   **FR-16:** The system must support the communal laundry/drying area
    and shared chiller as initial facilities.
-   **FR-17:** The system must not require physical QR stickers on
    individual belongings.

### Facility usage and activity log

-   **FR-18:** The system must store facility usage as separate sessions
    rather than treating facility placement as permanent item identity.
-   **FR-19:** An item may have no more than one active facility-use
    session at a time.
-   **FR-20:** Each usage session must store the item, facility type,
    activation timestamp, expiry timestamp, and current session status.
-   **FR-21:** The system must allow an owner to retrieve an item and
    end its active session.
-   **FR-22:** The system must allow an existing item to be activated
    again in a new session.
-   **FR-23:** The system must automatically log meaningful status
    changes, including actor/system, old status, new status, and
    timestamp.
-   **FR-24:** The system must not require residents to manually compose
    activity-log entries for normal status changes.

### Expiration

-   **FR-25:** The system must obtain expiration durations from
    backend-managed policies rather than hardcoding them in the mobile
    application.
-   **FR-26:** The initial laundry expiration policy must be 48 hours.
-   **FR-27:** The initial chiller `RAW` expiration policy must be 168
    hours.
-   **FR-28:** The initial chiller `INSTANT` expiration policy must be
    240 hours.
-   **FR-29:** The user-facing label for `INSTANT` must be "Makanan
    Instan & Matang".
-   **FR-30:** The system must automatically transition overdue active
    sessions to `EXPIRED`.
-   **FR-31:** The system must perform an expiry check in backend read
    paths where needed to avoid stale active status if the scheduled job
    is delayed.
-   **FR-32:** Expiration must not delete the permanent item record or
    automatically classify it as missing, stolen, or unsafe to consume.
-   **FR-33:** The system must notify the item owner and property owner
    when a session expires.
-   **FR-34:** A property owner must be able to configure policy
    durations. The effective duration for a session must be stored when
    that session is created; policy changes should apply to future
    sessions unless an explicit migration rule is approved.

### Incidents and claims

-   **FR-35:** The system must support missing, swapped/misplaced, and
    found incident reports.
-   **FR-36:** An incident report must store its type, reporter, related
    item when known, facility/location, description, evidence path(s),
    status, and timestamps.
-   **FR-37:** The system must not automatically classify a missing item
    as confirmed theft.
-   **FR-38:** The system must support private ownership claims with
    details visible only to authorized reviewers.
-   **FR-39:** The system must allow property owners to review claims
    and record decisions.
-   **FR-40:** The system must record important incident status changes
    and resolution actions in incident history.

### Dashboard and notifications

-   **FR-41:** The property-owner dashboard must show active inventory,
    expired sessions, open incidents, pending claims, and recent
    activity.
-   **FR-42:** The dashboard must support filtering by facility, room,
    category/type, and status where applicable.
-   **FR-43:** The system must generate notifications for expiry, new
    incidents, claim decisions, and important resolution changes.
-   **FR-44:** The system must avoid duplicate notifications for the
    same event.
-   **FR-45:** The system must use Firebase Cloud Messaging for mobile
    push notifications and retain notification records in the backend.

------------------------------------------------------------------------

## 5. Non-Goals (Out of Scope)

The MVP will not include:

-   Automatic theft detection or automatic identification of a person
    who took an item.
-   Automatic conclusions about a resident's guilt based on a
    missing-item report or activity log.
-   CCTV integration or automated video analysis.
-   AI-based image recognition or automatic matching of visually similar
    belongings.
-   Physical QR stickers or QR tags attached to every individual item.
-   In-app resident-to-resident chat.
-   Automatic deletion of expired item records.
-   Treating an expired chiller session as a food-safety determination
    or proof that food is spoiled.
-   A full analytics/BI suite beyond the operational owner dashboard.
-   Logging every screen view, tap, or minor interaction as a permanent
    activity event.
-   Registration of belongings kept exclusively inside private rooms;
    the registry focuses on items placed in shared facilities.

------------------------------------------------------------------------

## 6. Design Considerations

### Main user roles

**Resident** - Registers and manages their own belongings. - Activates
an item when placing it in a communal facility. - Retrieves an item or
starts a later usage session. - Views shared inventory with limited
owner information. - Reports missing, exchanged/misplaced, or found
items. - Submits and tracks ownership claims. - Receives notifications
and reviews their private item history.

**Property owner / manager** - Manages property and room records. -
Associates residents with rooms. - Views property-wide active inventory
and live activity. - Reviews incidents and ownership claims. - Records
follow-up and resolution status. - Configures expiration policies. -
Receives notifications for expired sessions and important incidents.

### Main application areas

1.  Authentication and account profile.
2.  Property/room membership and room QR entry.
3.  My Items / Private Ownership Log.
4.  Shared Inventory.
5.  Add/Edit Item.
6.  Facility-use activation and retrieval.
7.  Item Live Log.
8.  Missing / Swapped / Found reporting.
9.  Ownership Claims.
10. Notifications.
11. Property-owner dashboard and incident management.

### Visibility and privacy

-   Shared inventory should show the item and room number, with only
    limited owner identity.
-   Private owner contact information must not be publicly exposed.
-   Claim verification details must be private to the claimant and
    authorized reviewer(s).
-   Property owners should only access properties they manage.
-   A room QR is an entry point, not an authorization bypass; backend
    access checks remain mandatory.

### Status vocabulary

The product's agreed status vocabulary includes:

-   `REGISTERED`
-   `ACTIVE`
-   `EXPIRED`
-   `RETRIEVED`
-   `MISSING`
-   `FOUND`
-   `RETURNED`

These statuses apply to different lifecycle concepts and must not be
treated as interchangeable. In particular, `EXPIRED` means a
facility-use session passed its configured duration; it does not mean
`MISSING` or `STOLEN`. The detailed transition matrix remains an
implementation decision to finalize before coding.

### Initial item categories and expiration policy

  -----------------------------------------------------------------------------
  Facility         Internal         User-facing                Initial duration
                   category         category/examples     
  ---------------- ---------------- --------------------- ---------------------
  Laundry          `LAUNDRY`        Clothing: tops,                    48 hours
                                    bottoms, underwear,   
                                    sportswear            

  Laundry          `LAUNDRY`        Fabric/accessories:                48 hours
                                    towels, cloth/sarong, 
                                    hijab                 

  Chiller          `RAW`            Raw meat, chicken,                168 hours
                                    fish/seafood,         
                                    vegetables/fruit,     
                                    eggs, other raw       
                                    ingredients           

  Chiller          `INSTANT`        Instant noodles,                  240 hours
                                    packaged ready-to-eat 
                                    food, cooked meals,   
                                    home-cooked meals,    
                                    cooked side dishes,   
                                    leftovers,            
                                    ready-to-drink        
                                    beverages             
  -----------------------------------------------------------------------------

The `INSTANT` category is intentionally grouped under the user-facing
label "Makanan Instan & Matang" for the MVP. The expiration duration is
a facility occupancy rule only. It must not be presented as a
safe-consumption duration. Package use-by dates, storage temperature,
and food-safety guidance are separate concerns.

------------------------------------------------------------------------

## 7. Technical Considerations

### Proposed technology stack

-   **Mobile client:** Flutter (Android and iOS).
-   **Backend:** Laravel REST API.
-   **Database:** MySQL.
-   **Authentication:** Laravel Sanctum or another token-based API
    authentication configuration.
-   **Push notifications:** Firebase Cloud Messaging (FCM).
-   **Scheduled expiration:** Laravel Scheduler and scheduled
    command/job.
-   **File storage:** Laravel-supported local or object storage for item
    and incident photos; store only paths/storage keys in MySQL.

### Proposed database entities

  -----------------------------------------------------------------------
  Table                               Purpose / key relationships
  ----------------------------------- -----------------------------------
  `users`                             Resident and property-owner
                                      accounts

  `properties`                        Boarding-house/property records;
                                      owned or managed by users

  `rooms`                             Rooms belonging to a property

  `room_members`                      Many-to-many association between
                                      users and rooms

  `items`                             Permanent item identity, owner,
                                      category, photo path, descriptive
                                      details

  `item_categories`                   Category and subcategory
                                      definitions

  `expiration_policies`               Configurable duration by facility
                                      and category

  `item_usage`                        One row per facility-use session;
                                      references `items`

  `item_activity_logs`                Meaningful item/session status
                                      changes, actor/system, timestamp

  `incident_reports`                  Missing, swapped/misplaced, and
                                      found reports

  `item_claims`                       Private ownership claims associated
                                      with an item/report

  `incident_histories`                Incident review, status changes,
                                      and resolution actions

  `item_identifiers`                  Random room QR token and room
                                      association

  `notifications`                     In-app notification record and
                                      delivery state/device reference as
                                      needed
  -----------------------------------------------------------------------

### Important data-model rules

-   `items` stores permanent item identity and owner. Facility use
    belongs in `item_usage`.
-   One physical object equals one `items` row, even when multiple
    objects look alike.
-   `room_members` is required because a room may have multiple
    residents; do not store a single resident ID as the only room owner.
-   An item must have no more than one active `item_usage` session at a
    time.
-   `item_usage` should include at minimum: `item_id`, `facility_type`,
    `activated_at`, `expires_at`, `expired_at`, and `status`.
-   `item_activity_logs` should include at minimum: `item_usage_id`
    (nullable when appropriate), `old_status`, `new_status`,
    `changed_by` or system actor, and `created_at`.
-   `expiration_policies` should be backend-managed. Store the resolved
    `expires_at` on each usage session so a later policy change does not
    silently rewrite an existing session.
-   Photo binaries should not be stored directly in relational database
    rows; store file paths or object-storage keys.
-   Found reports can be represented through `incident_reports` with a
    report type rather than requiring a separate found-items table.
-   The API must enforce authorization and privacy rules; hiding fields
    only in Flutter is insufficient.

### Suggested API capability groups

-   Authentication and current-user profile.
-   Properties, rooms, room membership, and room QR resolution.
-   Item registration, owner item list, item detail, and item update.
-   Shared inventory query and filters.
-   Facility-use activation, retrieval, and status query.
-   Item activity history.
-   Incident creation, listing, detail, and status updates.
-   Ownership claim creation and review.
-   Owner dashboard summary and filtered operational data.
-   Notification listing and device-token registration.
-   Expiration policy management and scheduled expiry processing.

### Expiration processing logic

1.  When an owner activates an item in a facility, the API selects the
    applicable policy.
2.  The API creates an `item_usage` row with `activated_at` and
    calculated `expires_at`.
3.  A scheduled backend job finds active sessions whose expiry time has
    passed.
4.  Each eligible session is transitioned to `EXPIRED` once, with an
    idempotent system activity-log entry.
5.  The system creates notifications for the item owner and property
    owner.
6.  Backend inventory queries also ensure overdue sessions are not
    presented as active if the scheduled job has not yet run.
7.  If the resident retrieves the item after expiry, the session can be
    marked `RETRIEVED`; if the item is still in use, a new session can
    be created according to the product's transition rules.

### Security and reliability considerations

-   Use authorization policies on every property-, room-, item-, claim-,
    and incident-level endpoint.
-   Use unguessable QR tokens and allow token revocation.
-   Validate uploaded image types and sizes.
-   Keep private claim details and contact information out of
    shared-inventory responses.
-   Make expiration processing idempotent so retries do not create
    duplicate logs or notifications.
-   Validate state transitions on the backend, not only in the mobile
    client.
-   Use pagination for shared inventory, logs, incidents, and
    notifications.
-   Record timestamps consistently and display them in the property's
    local time zone.
-   Do not rely on push notification delivery as the only source of
    truth; important events must remain visible in the app.

------------------------------------------------------------------------

## 8. Success Metrics

The MVP pilot should measure:

-   **Registration completion:** percentage of residents who start and
    finish registering an item.
-   **Registration effort:** median time and number of steps required to
    register an item.
-   **Inventory freshness:** percentage of active sessions that are
    correctly retrieved, expired, or otherwise updated.
-   **Incident reporting adoption:** number of missing, swapped, and
    found reports created during the pilot.
-   **Incident follow-up:** percentage of reports that receive a manager
    review/status update.
-   **Resolution visibility:** percentage of incidents with a recorded
    final status and handling history.
-   **Notification reliability:** percentage of generated notifications
    successfully recorded and delivered to registered devices.
-   **Privacy compliance:** no unauthorized exposure of private owner
    contact details or claim information in testing.
-   **Operational usefulness:** resident and property-owner feedback on
    whether the shared inventory and incident workflow are clearer than
    the previous group-chat-only process.

Targets should be set after baseline testing with a pilot boarding
house; the current discovery has not established reliable numeric
baselines.

------------------------------------------------------------------------

## 9. Open Questions

These points remain to be confirmed before implementation:

1.  **Authentication method:** Should the MVP use email/password, phone
    number/OTP, or invitation-based accounts created by the property
    owner?
2.  **Property onboarding:** Can a property owner self-register a
    property, or must a platform administrator approve each property?
3.  **Resident onboarding:** How does a resident join a property and
    room: manager invitation, room code, QR scan, or a combination?
4.  **Owner identity visibility:** Should shared inventory show no owner
    name, a first name only, or a masked identity such as "Resident of
    Room 03"?
5.  **Status transition matrix:** What exact transitions are allowed
    between `REGISTERED`, `ACTIVE`, `EXPIRED`, `RETRIEVED`, `MISSING`,
    `FOUND`, and `RETURNED`, and which roles may perform each
    transition?
6.  **Incident visibility:** Should missing/swapped/found reports be
    visible to all residents in the property, or only the reporter,
    relevant owner, and property manager?
7.  **Claim matching:** Can a resident claim a found item directly, or
    must the property owner initiate/invite a claim review?
8.  **Expiration policy administration:** Can property owners change all
    policy durations, or are the initial values fixed by the platform
    for the MVP?
9.  **Food category detail:** Should the app capture package
    expiry/use-by date as an optional field in the MVP? This is separate
    from the 10-day facility session expiry.
10. **Dashboard platform:** Should the property-owner dashboard be part
    of the Flutter app, a responsive web dashboard, or both?
11. **Pilot scope:** How many properties, rooms, and residents should be
    supported in the first pilot?
12. **Competition submission constraints:** Confirm any required app
    package, demo video duration, platform, or submission-specific
    technical restrictions not covered by the current product discovery.

------------------------------------------------------------------------

## Appendix A --- Explicit MVP Scope

### Included in MVP

1.  Authentication and multi-resident room membership.
2.  Property and room management.
3.  Permanent room QR identifier.
4.  Individual item ownership registry.
5.  Private owner log.
6.  Centralized shared inventory for laundry/drying area and chiller.
7.  Facility-use sessions and item status changes.
8.  Automatic live activity log for meaningful status changes.
9.  Automatic expiry: laundry 48 hours, chiller RAW 7 days, chiller
    INSTANT 10 days.
10. Missing, swapped/misplaced, and found reports.
11. Private ownership claims and property-owner verification.
12. Property-owner dashboard and incident follow-up.
13. Real-time notifications for expiry and important incident/claim
    events.

### Deferred beyond MVP

-   CCTV integration.
-   AI image recognition or automatic visual matching.
-   Automated theft detection or culprit identification.
-   Resident-to-resident chat.
-   Advanced analytics.
-   Physical QR tags on individual items.

## Appendix B --- Competition Alignment

The product is intended to address a practical everyday problem through
a mobile-first, collaborative record and incident workflow.

Potential impact areas: - **Practical benefit:** better traceability and
follow-up for belongings in communal facilities. - **Uniqueness:**
combines item-level ownership records, shared inventory, automatic
usage-session logs, expiry handling, and incident/claim workflows. -
**Sustainability:** may reduce unnecessary food waste and loss of
reusable belongings by making ownership and follow-up clearer. This is
an intended impact to validate, not a guaranteed outcome. -
**Originality:** the implementation and product design must be developed
by the team and must not claim automated detection capabilities that are
not implemented.

The competition theme and judging rubric should be treated as external
submission context; the product requirements above describe the proposed
KOSGUARD MVP.
