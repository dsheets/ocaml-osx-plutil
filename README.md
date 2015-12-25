## The OS X plutil plist command as an OCaml library

```ocaml
# Plutil.to_human "<plist><dict><key>k</key><true/></dict></plist>";;
- : (bytes, bytes) Result.result = Result.Ok "{\n  \"k\" => 1\n}"
# Plutil.to_json "<plist><dict><key>k</key><true/></dict></plist>";;
- : (bytes, bytes) Result.result = Result.Ok "{\"k\":true}"
```

Includes conversion *to* and *from* plist **xml1**, **binary1**, and
**json** formats as well as JSON pretty-printing and a human-readable
format.
