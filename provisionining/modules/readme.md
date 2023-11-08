# Modules

index in the module name supose to indicate how far of how close to the user the module is. 
- `00` indicates the deepest level, having the least amount of dependencies
- `03` is the HTTP layer, closest to the end-user, thich depends on all the other layers
- The indices suppose to indicate also how dangerous is to change the module

The structure was inspired by 
https://developer.hashicorp.com/terraform/tutorials/modules/pattern-module-creation