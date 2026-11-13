# Calf register

Open it from the drawer: **Calf Register**.

## Where calves come from

- **Breeding cycles.** When a calving is recorded on a cow's breeding screen, the calf appears here with its dam, birth date, sex and outcome (kept as a heifer, sold with the amount, or awaiting outcome). Sex and birth date always come from the cycle.
- **Added by hand.** Tap **Add calf** for a calf that was bought in or born before you used the app: name, date of birth, sex, dam (optional), birth weight, notes, and a "Bought in" switch. These show as "Bought in" or "On farm".

## Details

Tap any calf to add or edit its **birth weight**, **weaning date** and **notes**. Rows show "32 kg at birth · Weaned on 3/4/2026" when set.

- For a calf from a breeding cycle, the first save creates its row in the `Calves` table linked by `breedingCycleId`. Until the outcome is recorded its stored sex is `unknown`; the cycle's sex is shown once recorded. **Breeding record** in the dialog opens the dam's breeding screen.
- A hand-entered calf can be deleted from its dialog (tap Delete twice).
- A `Calves` row whose cycle no longer has a calving date is still listed on its own, so its details are not lost.

## Code

- Table `Calves` (schema v10) in `lib/database/app_database.dart`; `insertCalf`, `updateCalf`, `watchCalves`, `deleteCalf`.
- Merge logic: `buildCalfRegister` in `lib/breeding/calf_register.dart`.
- Screen and dialogs: `lib/breeding/calf_register_screen.dart`, `lib/breeding/calf_dialogs.dart`.
