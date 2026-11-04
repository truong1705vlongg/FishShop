<?php
require_once __DIR__.'/bootstrap.php';
require_once __DIR__.'/../includes/rewards.php';
requireAdmin();$pdo=db();reward_schema($pdo);
if($_SERVER['REQUEST_METHOD']==='POST'){
    requirePost('admin/wallet_deposits.php');$id=(int)($_POST['id']??0);$decision=post_string('decision');
    if($id<1||!in_array($decision,['approve','reject'],true)){flash('error','Yêu cầu không hợp lệ.');redirect('admin/wallet_deposits.php');}
    try{$pdo->beginTransaction();$st=$pdo->prepare("SELECT id,user_id,amount,status FROM wallet_deposits WHERE id=? FOR UPDATE");$st->execute([$id]);$d=$st->fetch();if(!$d||$d['status']!=='pending')throw new DomainException('Yêu cầu đã được xử lý hoặc không tồn tại.');
        if($decision==='approve'){$pdo->prepare('INSERT INTO prize_wallets(user_id,balance) VALUES(?,?) ON DUPLICATE KEY UPDATE balance=balance+VALUES(balance)')->execute([(int)$d['user_id'],(int)$d['amount']]);$status='approved';}else{$status='rejected';}
        $pdo->prepare('UPDATE wallet_deposits SET status=?,reviewed_at=NOW(),reviewed_by=? WHERE id=?')->execute([$status,(int)current_user()['id'],$id]);$pdo->commit();flash('success',$status==='approved'?'Đã xác nhận và cộng tiền vào ví.':'Đã từ chối yêu cầu nạp tiền.');
    }catch(Throwable $ex){if($pdo->inTransaction())$pdo->rollBack();flash('error',$ex instanceof DomainException?$ex->getMessage():'Không thể xử lý yêu cầu.');}redirect('admin/wallet_deposits.php');
}
$rows=$pdo->query("SELECT d.*,u.fullname,u.username FROM wallet_deposits d JOIN users u ON u.id=d.user_id ORDER BY (d.status='pending') DESC,d.id DESC")->fetchAll();
$pageTitle='Yêu cầu nạp ví';include __DIR__.'/_header.php';
?>
<section class="page-intro"><h1>Yêu cầu nạp ví</h1><p>Chỉ xác nhận sau khi đã kiểm tra khoản chuyển đến.</p></section>
<div class="table-wrap"><table><thead><tr><th>Mã</th><th>Khách hàng</th><th>Số tiền</th><th>Thông tin đối chiếu</th><th>Tạo lúc</th><th>Trạng thái</th><th>Thao tác</th></tr></thead><tbody><?php foreach($rows as $r): ?><tr><td>#<?=(int)$r['id']?></td><td><?=e($r['fullname'])?> (<?=e($r['username'])?>)</td><td><?=money($r['amount'])?></td><td><?php if(($r['reference_mode']??'with_code')==='no_code'): ?><strong>Không mã nội dung</strong><br><small>Người chuyển: <?=e($r['sender_name']??'Chưa cung cấp')?></small><?php else: ?><strong>Nội dung: NAPVI <?=(int)$r['id']?></strong><br><small>Người chuyển: <?=e($r['sender_name']??'Chưa cung cấp')?></small><?php endif; ?></td><td><?=e($r['created_at'])?></td><td><?=['pending'=>'Chờ xác nhận','approved'=>'Đã cộng','rejected'=>'Từ chối'][$r['status']]?></td><td><?php if($r['status']==='pending'): ?><div class="voucher-table-actions"><form method="post"><?=csrf_field()?><input type="hidden" name="id" value="<?=(int)$r['id']?>"><input type="hidden" name="decision" value="approve"><button class="btn sm" type="submit">Xác nhận đã nhận tiền</button></form><form method="post"><?=csrf_field()?><input type="hidden" name="id" value="<?=(int)$r['id']?>"><input type="hidden" name="decision" value="reject"><button class="btn ghost sm" type="submit">Từ chối</button></form></div><?php endif; ?></td></tr><?php endforeach; ?></tbody></table></div>
<?php include __DIR__.'/_footer.php'; ?>
