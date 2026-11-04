<?php
require_once __DIR__.'/includes/auth.php';
require_once __DIR__.'/includes/rewards.php';
$user=requireLogin(); $pdo=db(); reward_schema($pdo); $uid=(int)$user['id'];
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    requirePost('wallet.php');
    $raw = trim(post_string('amount'));
    $referenceMode = 'no_code';
    $senderName = trim(post_string('sender_name'));
    if (!ctype_digit($raw) || (int)$raw < 5000 || (int)$raw > 50000000) {
        flash('error', 'Số tiền nạp từ 5.000 đ đến 50.000.000 đ.');
        redirect('wallet.php');
    }
    if ($senderName === '' || mb_strlen($senderName) > 100) {
        flash('error', 'Vui lòng nhập tên người chuyển khoản (tối đa 100 ký tự).');
        redirect('wallet.php');
    }
    try {
        $st = $pdo->prepare("INSERT INTO wallet_deposits(user_id,amount,reference_mode,sender_name,status) VALUES(?,?,?,?,'pending')");
        $st->execute([$uid, (int)$raw, $referenceMode, $senderName]);
        $depositId = (int)$pdo->lastInsertId();
        flash('success', 'Đã tạo yêu cầu nạp tiền. Hãy chuyển khoản theo thông tin bên dưới.');
        redirect('wallet.php?deposit=' . $depositId);
    } catch (Throwable $ex) {
        flash('error', 'Chưa thể tạo yêu cầu nạp tiền. Vui lòng thử lại.');
        redirect('wallet.php');
    }
}$wallet=prize_wallet($pdo,$uid);
$st=$pdo->prepare('SELECT id,amount,reference_mode,sender_name,status,created_at FROM wallet_deposits WHERE user_id=? ORDER BY id DESC LIMIT 20');$st->execute([$uid]);$requests=$st->fetchAll();
$selectedId=(int)($_GET['deposit']??0);$selectedDeposit=null;
if($selectedId>0){$st=$pdo->prepare('SELECT id,amount,reference_mode,sender_name,status,created_at FROM wallet_deposits WHERE id=? AND user_id=?');$st->execute([$selectedId,$uid]);$selectedDeposit=$st->fetch()?:null;}
$qrFile=__DIR__.'/payment/NapTienDi.jpg';$pageTitle='Nạp tiền ví vòng quay';include __DIR__.'/includes/header.php';
?>
<p class="crumb"><a href="<?=url('wheel.php')?>">Vòng quay</a> / Nạp tiền ví</p>
<section class="card form-card">
  <h1>Nạp tiền vào ví vòng quay</h1><p>Số dư hiện tại: <strong><?=money($wallet['balance'])?></strong></p>
  <form method="post" action="<?=url('wallet.php')?>"><?=csrf_field()?>
    <div class="field"><label for="amount">Số tiền muốn nạp (VNĐ)</label><input id="amount" name="amount" type="number" min="5000" max="50000000" step="1000" required placeholder="Ví dụ: 50000"></div>
    <div class="field"><label for="sender_name">Tên người chuyển khoản</label><input id="sender_name" name="sender_name" type="text" maxlength="100" required autocomplete="name" placeholder="Tên chủ tài khoản ngân hàng"></div>
    <div class="wallet-topup-actions"><button class="btn" type="submit">Tạo yêu cầu nạp tiền qua QR</button></div>
  </form>
  <p class="hint">Không cần mã nội dung chuyển khoản. Nhập đúng tên chủ tài khoản để cửa hàng đối chiếu giao dịch và xác nhận cộng tiền.</p>
</section>
<style>.wallet-topup-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:12px}.wallet-topup-actions button{flex:1;min-width:190px}</style>
<?php if($selectedDeposit && $selectedDeposit['status']==='pending'): ?>
<section class="card wallet-qr-card" style="margin-top:20px">
  <h2>Quét mã QR để chuyển khoản</h2>
  <?php if(is_file($qrFile)): ?><div class="qr"><img src="<?=url('payment/NapTienDi.jpg')?>?v=<?=filemtime($qrFile)?>" alt="Mã QR chuyển khoản nạp ví"></div><?php else: ?><div class="qr-missing">Chưa có ảnh QR thanh toán. Vui lòng liên hệ cửa hàng.</div><?php endif; ?>
  <ol class="steps"><li>Chuyển đúng số tiền: <b><?=money($selectedDeposit['amount'])?></b>.</li><li>Tên người chuyển: <b><?=e($selectedDeposit['sender_name'])?></b>.</li><?php if($selectedDeposit['reference_mode']==='no_code'): ?><li>Để trống nội dung chuyển khoản, không nhập mã.</li><li>Cửa hàng sẽ đối chiếu thủ công theo số tiền, thời điểm và tên người chuyển.</li><?php else: ?><li>Nội dung chuyển khoản: <b>NAPVI <?= (int)$selectedDeposit['id'] ?></b>.</li><?php endif; ?><li>Chờ cửa hàng xác nhận; số dư chỉ được cộng sau khi giao dịch đã nhận.</li></ol>
  <p class="hint">Mã yêu cầu #<?= (int)$selectedDeposit['id'] ?> · Trạng thái: Chờ xác nhận</p>
</section>
<?php endif; ?>
<section class="card" style="margin-top:20px"><h2>Lịch sử yêu cầu nạp tiền</h2>
  <?php if(!$requests): ?><p>Chưa có yêu cầu nạp tiền.</p><?php else: ?><div class="table-wrap"><table><thead><tr><th>Mã</th><th>Số tiền</th><th>Đối chiếu</th><th>Ngày tạo</th><th>Trạng thái</th></tr></thead><tbody>
  <?php foreach($requests as $r): ?><tr><td><a href="<?=url('wallet.php?deposit='.(int)$r['id'])?>">#<?=(int)$r['id']?></a></td><td><?=money($r['amount'])?></td><td><?=$r['reference_mode']==='no_code'?'Không mã nội dung':'NAPVI '.(int)$r['id']?></td><td><?=e($r['created_at'])?></td><td><?=['pending'=>'Chờ xác nhận','approved'=>'Đã cộng tiền','rejected'=>'Từ chối'][$r['status']]?></td></tr><?php endforeach; ?>
  </tbody></table></div><?php endif; ?>
</section>
<?php include __DIR__.'/includes/footer.php'; ?>
