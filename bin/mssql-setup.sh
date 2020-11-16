#!/bin/bash

set -oe pipefail

/opt/mssql-init/bin/mssql-defaults.sh
/opt/mssql-init/bin/mssql-bacpac.sh
/opt/mssql-init/bin/mssql-scripts.sh
