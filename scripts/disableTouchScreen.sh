
#!/bin/bash

id=$(xinput --list --id-only 'ELAN24F0:00 04F3:24F0')

echo "disabling touch screen device $id"
xinput disable $id
