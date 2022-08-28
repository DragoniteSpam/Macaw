{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "MacawDLL",
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
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","filename":"Macaw.dll","origname":"","init":"","final":"","kind":1,"uncompress":false,"functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__macaw_generate","externalName":"macaw_generate","kind":1,"help":"macaw_generate(destination_buffer, w, h)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            2,
            2,
          ],},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__macaw_set_seed","externalName":"macaw_set_seed","kind":1,"help":"macaw_set_seed(seed)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
          ],},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__macaw_version","externalName":"macaw_version","kind":1,"help":"macaw_version()","hidden":false,"returnType":1,"argCount":0,"args":[],},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__macaw_set_octaves","externalName":"macaw_set_octaves","kind":1,"help":"__macaw_set_octaves(octaves)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
          ],},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__macaw_set_height","externalName":"macaw_set_height","kind":1,"help":"__macaw_set_height(height)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
          ],},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__macaw_to_sprite","externalName":"macaw_to_sprite","kind":1,"help":"__macaw_to_sprite(in, out, len)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
            1,
            2,
          ],},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"__macaw_to_vbuff","externalName":"macaw_to_vbuff","kind":1,"help":"__macaw_to_vbuff(in, out, w, h)","hidden":false,"returnType":1,"argCount":0,"args":[
            1,
            1,
            2,
            2,
          ],},
      ],"constants":[],"ProxyFiles":[],"copyToTargets":35184372088896,"order":[
        {"name":"__macaw_generate","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"__macaw_set_seed","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"__macaw_version","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"__macaw_set_octaves","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"__macaw_set_height","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"__macaw_to_sprite","path":"extensions/MacawDLL/MacawDLL.yy",},
        {"name":"__macaw_to_vbuff","path":"extensions/MacawDLL/MacawDLL.yy",},
      ],},
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
  "iosplistinject": "",
  "tvosplistinject": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidactivityinject": "",
  "gradleinject": "",
  "androidcodeinjection": "",
  "hasConvertedCodeInjection": true,
  "ioscodeinjection": "",
  "tvoscodeinjection": "",
  "iosSystemFrameworkEntries": [],
  "tvosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
  "IncludedResources": [],
  "androidPermissions": [],
  "copyToTargets": 144150411102650606,
  "iosCocoaPods": "",
  "tvosCocoaPods": "",
  "iosCocoaPodDependencies": "",
  "tvosCocoaPodDependencies": "",
  "parent": {
    "name": "Macaw",
    "path": "Macaw.yyp",
  },
}