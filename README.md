# vrising-bash

Follow instructions:

https://aws.amazon.com/blogs/gametech/hosting-your-own-dedicated-valheim-server-in-the-cloud/

Load Amazon's Cloud formation script into new cloud formation stack:

https://raw.githubusercontent.com/aws-samples/personal-game-server-manager/main/mcCFNGamingServerSolution.YAML

Change valheim.sh with:

https://raw.githubusercontent.com/hlista/vrising-bash/main/vrising.sh

Minimum t3a.medium is needed to run server

Set UDP ports from 27015 to 27016

Set TCP port 22 (errored out for me when TCP wasn't set)
