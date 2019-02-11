# Script: nightscout-polybar

A script that fetches your current blood sugar and trend from Nightscout and displays this information on polybar.

## Dependencies

None

## Configuration

Change these values:
```
URL: the url to your nightscout site
USEMMOL: true if you use mmol/l units, false otherwise
```

## Module

```ini
[module/nightscout]
type = custom/script
exec = ~/polybar-scripts/nightscout.sh
interval = 60
...
```

