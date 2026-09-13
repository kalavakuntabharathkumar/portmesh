package demo.transaction;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

@RestController
@RequestMapping("/transactions")
public class TransactionController {
  private final Map<Integer, List<Map<String,Object>>> tx = new HashMap<>();
  private final AtomicInteger ids = new AtomicInteger(1);

  @GetMapping("/health")
  public Map<String,String> health(){ return Map.of("service","transaction","status","ok"); }

  @PostMapping
  public synchronized Map<String,Object> create(@RequestBody Map<String,Object> body) {
    Map<String,Object> copy = new HashMap<>(body);
    copy.put("transaction_id", ids.getAndIncrement());
    copy.put("status", "COMPLETED");
    int portfolio = ((Number) body.getOrDefault("portfolio_id",1)).intValue();
    tx.computeIfAbsent(portfolio,k->new ArrayList<>()).add(copy);
    return copy;
  }

  @GetMapping("/{portfolioId}")
  public List<Map<String,Object>> list(@PathVariable int portfolioId) {
    return tx.getOrDefault(portfolioId, List.of());
  }
}
