# uninterruptible-sleeper

Clone this repository.

Create a new OCP project:
```
oc new-project fedora
```

Make the project privileged:
```
privileged ()
{ 
    oc label ns $1 security.openshift.io/scc.podSecurityLabelSync="false" --overwrite=true;
    oc label ns $1 pod-security.kubernetes.io/enforce=privileged --overwrite=true;
    oc label ns $1 pod-security.kubernetes.io/warn=privileged --overwrite=true;
    oc label ns $1 pod-security.kubernetes.io/audit=privileged --overwrite=true
}
privileged fedora
```

```
oc adm policy add-scc-to-user privileged -z default
```

Deploy the pods (the environment must be connected):
```
make deploy-pod
```

Delete one of the pods:
```
oc delete pod fedora-deployment-8457f855c7-d2rg8 --grace-period=3
```

Check OCP logs:
```
(...)
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.629884893Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.635884960Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.642163044Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.648096394Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.653786276Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.659958186Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.665780952Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
Feb 05 22:08:55 30-d0-42-da-54-80 crio[4966]: time="2024-02-05 22:08:55.671771243Z" level=warning msg="Stopping container cfad21ee605f5acec412c1b0d1f4f1141af640fbf0037b0dbe917e29f351cb1d with stop signal timed out. Killing"
(...)
```
