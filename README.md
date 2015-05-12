# groupSMS
Easy way to send group SMS texts to a csv of phone numbers
=======

This script was created using Coffeescript and is run with node. Uses a few node modules: fast-csv for parsing, prompt for input, q for promises, env-file for secrets, and twilio for actual SMS sending. Since dependencies are not large, 'node_modules' folder is included instead of package.json for installation.

Since the use case stated in the document was for hackathons, this tool is not super robust, but it it should be good enough to handle basic cases.

Assumes valid formatting of CSV (just a list of phone numbers)

Contact: Colin Man; colinman(at)stanford.edu

=======
Run with:

$ node send.js [phone.csv]

NOTE: must fill in .env file with variables as follows:

      SID=[Twilio SID]
      token=[Twilio Token]
      originNumber=[Origin Number (+XXXXXXXXXXX)