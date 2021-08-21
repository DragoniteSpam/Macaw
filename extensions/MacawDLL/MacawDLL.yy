{
  "optionsFile": "options.json",
  "options": [],
  "exportToGame": true,
  "supportedTargets": -1,
  "extensionVersion": "0.0.1",
  "packageId": "",
  "productId": "",
  "author": "",
  "date": "2021-08-20T23:55:43.0420192-04:00",
  "license": "",
  "description": "",
  "helpfile": "",
  "iosProps": false,
  "tvosProps": false,
  "androidProps": false,
  "installdir": "",
  "files": [
    {"filename":"Macaw.dll","origname":"","init":"","final":"","kind":1,"uncompress":false,"functions":[
        {"externalName":"macaw_generate","kind":1,"help":"macaw_generate(destination_buffer, w, h, octaves)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            2,
            2,
          ],"resourceVersion":"1.0","name":"macaw_generate","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"macaw_set_seed","kind":1,"help":"macaw_set_seed(seed)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
          ],"resourceVersion":"1.0","name":"macaw_set_seed","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"macaw_version","kind":1,"help":"macaw_version()","hidden":false,"returnType":1,"argCount":0,"args":[],"resourceVersion":"1.0","name":"macaw_version","tags":[],"resourceType":"GMExtensionFunction",},
      ],"constants":[],"ProxyFiles":[],"copyToTargets":-1,"order":[
        {"name":"macaw_generate","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"macaw_set_seed","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"macaw_version","path":"extensions/MacawDLL/MacawDLL.yy",},
      ],"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMExtensionFile",},
  ],
  "classname": "",
  "tvosclassname": null,
  "tvosdelegatename": null,
  "iosdelegatename": "",
  "androidclassname": "",
  "sourcedir": "",
  "androidsourcedir": "",
  "macsourcedir": "",
  "maccompilerflags": "",
  "tvosmaccompilerflags": "",
  "maclinkerflags": "",
  "tvosmaclinkerflags": "",
  "iosplistinject": null,
  "tvosplistinject": null,
  "androidinject": null,
  "androidmanifestinject": null,
  "androidactivityinject": null,
  "gradleinject": null,
  "iosSystemFrameworkEntries": [],
  "tvosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
  "IncludedResources": [],
  "androidPermissions": [],
  "copyToTargets": 35184372088896,
  "iosCocoaPods": "",
  "tvosCocoaPods": "",
  "iosCocoaPodDependencies": "",
  "tvosCocoaPodDependencies": "",
  "parent": {
    "name": "perlin noise tests",
    "path": "perlin noise tests.yyp",
  },
  "resourceVersion": "1.2",
  "name": "MacawDLL",
  "tags": [],
  "resourceType": "GMExtension",
}