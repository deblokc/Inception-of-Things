# Inception of Things

This project is an introduction to the art of DevOps.

## P1

In the first part we setup 2 machines with K3S and custom ip using Vagrant. One machine is the Server and the other is a Server Worker.

## P2

In part 2 we setup 3 web applications that run on our K3S instance. App2 needs to run have 3 pods. We setup an ingress to reroute the request depending on the HOST onto the required app.
We also added a cookie for app2 which allow to stay on the same pod, else we connect to a new pod each time (they switch in a round robin manner).

```
HOST=app1.com to app1
HOST=app2.com to app2
Any other HOST to app3
```

## P3

In part 3 we need to continuously integrate a github repository using Argo CD and K3D. When a push is made on the repository Argo CD will replace the pod with an up-to-date version.

## Bonus

The bonus part is similar to P3 but now we need to host a local gitlab in which the repository will be hosted. To do this we used the helmchart to install a gitlab and changed a few value to make it as light as possible.
