#!/bin/sh

usage () {
    cat <<__EOF__
usage: $(basename $0) [-hlp] [-u user] [-X args] [-d args]
  -h        print this help text
  -l        print list of files to download
  -p        prompt for password
  -u user   download as a different user
  -X args   extra arguments to pass to xargs
  -d args   extra arguments to pass to the download program

__EOF__
}

username=whenney
xargsopts=
prompt=
list=
while getopts hlpu:xX:d: option
do
    case $option in
    h)  usage; exit ;;
    l)  list=yes ;;
    p)  prompt=yes ;;
    u)  prompt=yes; username="$OPTARG" ;;
    X)  xargsopts="$OPTARG" ;;
    d)  download_opts="$OPTARG";;
    ?)  usage; exit 2 ;;
    esac
done

if test -z "$xargsopts"
then
   #no xargs option speficied, we ensure that only one url
   #after the other will be used
   xargsopts='-L 1'
fi

if [ "$prompt" != "yes" ]; then
   # take password (and user) from netrc if no -p option
   if test -f "$HOME/.netrc" -a -r "$HOME/.netrc"
   then
      grep -ir "dataportal.eso.org" "$HOME/.netrc" > /dev/null
      if [ $? -ne 0 ]; then
         #no entry for dataportal.eso.org, user is prompted for password
         echo "A .netrc is available but there is no entry for dataportal.eso.org, add an entry as follows if you want to use it:"
         echo "machine dataportal.eso.org login whenney password _yourpassword_"
         prompt="yes"
      fi
   else
      prompt="yes"
   fi
fi

if test -n "$prompt" -a -z "$list"
then
    trap 'stty echo 2>/dev/null; echo "Cancelled."; exit 1' INT HUP TERM
    stty -echo 2>/dev/null
    printf 'Password: '
    read password
    echo ''
    stty echo 2>/dev/null
fi

# use a tempfile to which only user has access 
tempfile=`mktemp /tmp/dl.XXXXXXXX 2>/dev/null`
test "$tempfile" -a -f $tempfile || {
    tempfile=/tmp/dl.$$
    ( umask 077 && : >$tempfile )
}
trap 'rm -f $tempfile' EXIT INT HUP TERM

echo "auth_no_challenge=on" > $tempfile
# older OSs do not seem to include the required CA certificates for ESO
echo "check-certificate=off"  >> $tempfile
if [ -n "$prompt" ]; then
   echo "--http-user=$username" >> $tempfile
   echo "--http-password=$password" >> $tempfile

fi
WGETRC=$tempfile; export WGETRC

unset password

if test -n "$list"
then cat
else xargs $xargsopts wget $download_opts 
fi <<'__EOF__'
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:40:00.862/HAWKI.2007-12-02T06:40:00.862.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:01:30.982/HAWKI.2007-12-02T07:01:30.982.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:51:56.087.NL/HAWKI.2008-11-09T06:51:56.087.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:43:01.791/HAWKI.2008-11-09T06:43:01.791.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:48:39.414.NL/HAWKI.2008-11-09T06:48:39.414.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:22:31.160.NL/HAWKI.2008-11-10T09:22:31.160.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:44:43.327/HAWKI.2008-11-09T06:44:43.327.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:45:17.612/HAWKI.2008-11-09T06:45:17.612.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:01:44.125/HAWKI.2008-11-09T07:01:44.125.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:03:22.467.NL/HAWKI.2008-11-09T07:03:22.467.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:44:08.465.NL/HAWKI.2008-11-09T06:44:08.465.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:51:56.087/HAWKI.2008-11-09T06:51:56.087.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:12:59.958/HAWKI.2008-11-09T07:12:59.958.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:07:26.055/HAWKI.2008-11-10T05:07:26.055.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:12:43.577/HAWKI.2008-01-27T00:12:43.577.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:47:35.372/HAWKI.2008-11-09T06:47:35.372.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:46:48.448/HAWKI.2007-12-02T06:46:48.448.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:42:26.928/HAWKI.2008-11-09T06:42:26.928.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:33:22.848/HAWKI.2007-12-02T06:33:22.848.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:51:16.034.NL/HAWKI.2007-12-02T06:51:16.034.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:12:59.958.NL/HAWKI.2008-11-09T07:12:59.958.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:28:46.228.NL/HAWKI.2008-11-10T09:28:46.228.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:31:41.206.NL/HAWKI.2008-11-09T07:31:41.206.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:56:51.069/HAWKI.2008-11-09T06:56:51.069.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:21:04.029/HAWKI.2008-11-10T05:21:04.029.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:50:17.742/HAWKI.2008-11-09T06:50:17.742.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:08:01.339.NL/HAWKI.2007-12-02T07:08:01.339.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:27:54.812/HAWKI.2008-11-09T07:27:54.812.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:08:01.339/HAWKI.2007-12-02T07:08:01.339.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:05:32.499.NL/HAWKI.2008-11-09T07:05:32.499.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:56:51.069.NL/HAWKI.2008-11-09T06:56:51.069.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:44:28.408.NL/HAWKI.2007-12-02T06:44:28.408.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:28:23.108.NL/HAWKI.2007-12-02T06:28:23.108.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:35:42.782/HAWKI.2007-12-02T06:35:42.782.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:09:16.227/HAWKI.2008-11-09T07:09:16.227.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:58:29.389/HAWKI.2008-11-09T06:58:29.389.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:20:16.351.NL/HAWKI.2007-12-02T06:20:16.351.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:45:51.899.NL/HAWKI.2008-11-09T06:45:51.899.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:55:12.733/HAWKI.2008-11-09T06:55:12.733.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:46:26.809.NL/HAWKI.2008-11-09T06:46:26.809.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:28:23.108/HAWKI.2007-12-02T06:28:23.108.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:03:22.467/HAWKI.2008-11-09T07:03:22.467.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:54:40.801/HAWKI.2008-01-27T00:54:40.801.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:26:01.875/HAWKI.2007-12-02T06:26:01.875.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:42:26.928.NL/HAWKI.2008-11-09T06:42:26.928.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:43:01.791.NL/HAWKI.2008-11-09T06:43:01.791.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:50:17.742.NL/HAWKI.2008-11-09T06:50:17.742.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:00:07.713.NL/HAWKI.2008-11-09T07:00:07.713.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:51:37.276/HAWKI.2008-01-27T00:51:37.276.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:45:17.612.NL/HAWKI.2008-11-09T06:45:17.612.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:22:31.160/HAWKI.2008-11-10T09:22:31.160.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:58:29.389.NL/HAWKI.2008-11-09T06:58:29.389.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:45:25.968/HAWKI.2008-01-27T00:45:25.968.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:39:28.802/HAWKI.2008-01-27T00:39:28.802.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:57:36.879/HAWKI.2007-12-02T06:57:36.879.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:46:26.809/HAWKI.2008-11-09T06:46:26.809.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:46:48.448.NL/HAWKI.2007-12-02T06:46:48.448.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:53:37.380/HAWKI.2007-12-02T06:53:37.380.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:47:35.372.NL/HAWKI.2008-11-09T06:47:35.372.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:39:08.624/HAWKI.2008-11-09T07:39:08.624.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:04:02.933/HAWKI.2007-12-02T07:04:02.933.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:01:25.682.NL/HAWKI.2008-11-10T05:01:25.682.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:20:27.388/HAWKI.2008-11-09T07:20:27.388.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T01:03:43.680/HAWKI.2008-01-27T01:03:43.680.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:33:22.848.NL/HAWKI.2007-12-02T06:33:22.848.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:28:46.228/HAWKI.2008-11-10T09:28:46.228.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:21:04.029.NL/HAWKI.2008-11-10T05:21:04.029.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:26:41.204/HAWKI.2008-11-10T09:26:41.204.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:01:30.982.NL/HAWKI.2007-12-02T07:01:30.982.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:20:27.388.NL/HAWKI.2008-11-09T07:20:27.388.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:53:34.411.NL/HAWKI.2008-11-09T06:53:34.411.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:55:12.733.NL/HAWKI.2008-11-09T06:55:12.733.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:24:47.755.NL/HAWKI.2008-11-10T05:24:47.755.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:24:47.755/HAWKI.2008-11-10T05:24:47.755.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:16:15.402.NL/HAWKI.2008-11-10T09:16:15.402.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:53:03.519/HAWKI.2008-01-27T00:53:03.519.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:51:16.034/HAWKI.2007-12-02T06:51:16.034.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:16:43.678.NL/HAWKI.2008-11-09T07:16:43.678.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:20:16.351/HAWKI.2007-12-02T06:20:16.351.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:10:31.921.NL/HAWKI.2007-12-02T07:10:31.921.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:53:34.411/HAWKI.2008-11-09T06:53:34.411.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:53:37.380.NL/HAWKI.2007-12-02T06:53:37.380.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:47:01.089/HAWKI.2008-11-09T06:47:01.089.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:17:17.606.NL/HAWKI.2008-11-10T05:17:17.606.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:45:51.899/HAWKI.2008-11-09T06:45:51.899.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:04:02.933.NL/HAWKI.2007-12-02T07:04:02.933.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:24:36.180/HAWKI.2008-11-10T09:24:36.180.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:57:36.879.NL/HAWKI.2007-12-02T06:57:36.879.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:05:32.499/HAWKI.2008-11-09T07:05:32.499.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:40:00.862.NL/HAWKI.2007-12-02T06:40:00.862.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:44:43.327.NL/HAWKI.2008-11-09T06:44:43.327.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:39:08.624.NL/HAWKI.2008-11-09T07:39:08.624.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:00:51.403/HAWKI.2008-11-10T05:00:51.403.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:35:42.782.NL/HAWKI.2007-12-02T06:35:42.782.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:35:24.918/HAWKI.2008-11-09T07:35:24.918.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:26:41.204.NL/HAWKI.2008-11-10T09:26:41.204.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:26:01.875.NL/HAWKI.2007-12-02T06:26:01.875.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:16:15.402/HAWKI.2008-11-10T09:16:15.402.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:09:16.227.NL/HAWKI.2008-11-09T07:09:16.227.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:43:36.123.NL/HAWKI.2008-11-09T06:43:36.123.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:00:51.403.NL/HAWKI.2008-11-10T05:00:51.403.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:48:39.414/HAWKI.2008-11-09T06:48:39.414.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:27:54.812.NL/HAWKI.2008-11-09T07:27:54.812.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T06:44:28.408/HAWKI.2007-12-02T06:44:28.408.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:07:26.055.NL/HAWKI.2008-11-10T05:07:26.055.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:20:25.453.NL/HAWKI.2008-11-10T09:20:25.453.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T01:07:53.211/HAWKI.2008-01-27T01:07:53.211.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:31:41.206/HAWKI.2008-11-09T07:31:41.206.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:44:08.465/HAWKI.2008-11-09T06:44:08.465.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:18:20.441.NL/HAWKI.2008-11-10T09:18:20.441.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:16:43.678/HAWKI.2008-11-09T07:16:43.678.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:01:25.682/HAWKI.2008-11-10T05:01:25.682.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:24:11.098/HAWKI.2008-11-09T07:24:11.098.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2007-12-02T07:10:31.921/HAWKI.2007-12-02T07:10:31.921.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:24:36.180.NL/HAWKI.2008-11-10T09:24:36.180.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:20:25.453/HAWKI.2008-11-10T09:20:25.453.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T09:18:20.441/HAWKI.2008-11-10T09:18:20.441.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:35:24.918.NL/HAWKI.2008-11-09T07:35:24.918.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:47:01.089.NL/HAWKI.2008-11-09T06:47:01.089.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-10T05:17:17.606/HAWKI.2008-11-10T05:17:17.606.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:01:44.125.NL/HAWKI.2008-11-09T07:01:44.125.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T06:43:36.123/HAWKI.2008-11-09T06:43:36.123.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:36:55.553/HAWKI.2008-01-27T00:36:55.553.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-01-27T00:46:37.830/HAWKI.2008-01-27T00:46:37.830.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:00:07.713/HAWKI.2008-11-09T07:00:07.713.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/whenney/491163/SAF/HAWKI.2008-11-09T07:24:11.098.NL/HAWKI.2008-11-09T07:24:11.098.NL.txt"

__EOF__
