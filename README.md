# EventSourcery Generators

An opinionated CLI tool for building event sourced systems with EventSourcery.

## Cheat Sheet
```
rm -rf calendar
eventsourcery new calendar --skip-bundle --skip-db

eventsourcery generate:command appointment cancel
eventsourcery generate:command appointment reschedule
eventsourcery generate:command appointment schedule
eventsourcery generate:command invitation reject
eventsourcery generate:command invitation accept
eventsourcery generate:command invitation extend

eventsourcery generate:query daily_appointments
eventsourcery generate:query weekly_appointments
eventsourcery generate:query monthly_appointments
eventsourcery generate:query yearly_appointments
eventsourcery generate:query appointment_detail
eventsourcery generate:query invitation_detail

eventsourcery generate:dep invitation_email_notifier
```
