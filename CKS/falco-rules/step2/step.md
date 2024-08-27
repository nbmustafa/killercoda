# Step 3: Monitor Falco Alerts and Mitigate the Threats

Monitor the Falco logs to detect which containers have triggered the security rules. Once identified, scale down the corresponding deployments to 0 replicas to mitigate the threats.

1. **Monitor Falco Logs**:
   View the Falco logs to identify which containers have triggered the security rules:

   ```sh
   sudo cat /var/log/syslog | grep "Falco"


<details>
  <summary>Solution</summary>

1. **Mitigate the Threats**: Scale down the compromised deployments to 0 replicas to mitigate the threats:

  ```bash
  kubectl scale deployment netcat-deployment --replicas=0 -n falco-test
  kubectl scale deployment aws-creds-deployment --replicas=0 -n falco-test
  ```

</details>
