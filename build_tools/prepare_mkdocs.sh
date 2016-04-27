#!/bin/sh

# Prepare mkdocs configuration files and docs folder for a specific language
# (By default english)
# It supposes that seafile-docs translations have already been compiled.

# Uncomment to debug
set -x

# Read Arguments
# See <http://mywiki.wooledge.org/BashFAQ>
language=
verbose=0 # Variables to be evaluated as shell arithmetic should be initialized to a default or validated beforehand.

while :; do
    case $1 in
        -l|--language)       # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                language="$2"
                shift
            else
                printf 'ERROR: "--language" requires a non-empty option argument.\n' >&2
                exit 1
            fi
            ;;
        --language=?*)
            language=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --language=)         # Handle the case of an empty --language=
            printf 'ERROR: "--language" requires a non-empty option argument.\n' >&2
            exit 1
            ;;
        -v|--verbose)
            verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done

# Environment definition
MKDOCSDIR="$PWD/.."
MKDOCSDOCSDIR=${MKDOCSDIR}/docs
SEAFILEDOCSDIR=${MKDOCSDIR}/seafile-docs
# This file needs to exist
FILELIST=${SEAFILEDOCSDIR}/po/POTFILES.in
if [ ! -f "${FILELIST}" ]; then
  echo "${FILELIST} file does not exist ! Aborting."
  exit 1
fi

LOCALEDIR=${SEAFILEDOCSDIR}/locale
# End of environment definition

# Compute TARGETLANGUAGEDIR
# When not defined English website will be built
TARGETLANGUAGEDIR=
if [ -n "${language}" ]; then
   TARGETLANGUAGEDIR=${LOCALEDIR}/${language}

   # Check for existing compiled pages
   if [ ! -d "${TARGETLANGUAGEDIR}" ]; then
      echo "There is no translated pages in TARGETLANGUAGEDIR: ${TARGETLANGUAGEDIR} ! Please compile them. Aborting."
      exit 2;
   fi
fi


# To copy markdown files to mkdocs docs directory
copy_official_md_files() {
   rm -rf "${MKDOCSDOCSDIR}"
   mkdir "${MKDOCSDOCSDIR}"
   cd ${SEAFILEDOCSDIR}
   while IFS= read -r file; do
      cp -p --parents "${file}" "${MKDOCSDOCSDIR}"
   done < "${FILELIST}"
}


# Main preparation
# 1- Copy files to docs directory
# 2- Create Table Of Content (and index.md file)

currentPWD="$PWD"
if [ ! -n "${TARGETLANGUAGEDIR}" ]; then
   # 1- Copy English files to docs
   copy_official_md_files

   # 2- Create Table Of Content (and index.md file)
   cd "$currentPWD"
#   ./create_TOC.sh
else
   # A specific language has been asked

   # 1- Copy files to docs
   # 1-a Use official files in case of partial locale files
   copy_official_md_files

   # 1-b Copy existing locale files
   cd "$TARGETLANGUAGEDIR"
   find . -type f | while IFS= read -r file; do
       cp -p "${file}" "${MKDOCSDOCSDIR}/${file}"
   done

   # 2- Create Table Of Content (and index.md file)
   cd "$currentPWD"
#   ./create_TOC.sh
fi
