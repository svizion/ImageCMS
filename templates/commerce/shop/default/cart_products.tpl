{if count($items)}
<caption>Корзина</caption>
<colgroup>
    <col span="1" width="120">
    <col span="1" width="396">
    <col span="1" width="160">
    <col span="1" width="140">
    <col span="1" width="160">
    <col span="1" width="25">
</colgroup>
<tbody>
    {foreach $items as $key=>$item}                
    <tr>
        <td>
            <a href="{shop_url('product/' . $item.model->getUrl())}" class="photo_block">
                <img src="{productImageUrl($item.model->getMainModimage())}" alt="{echo ShopCore::encode($item.model->getName())}"/>
            </a>
        </td>
        <td>
            <a href="{shop_url('product/' . $item.model->getUrl())}">{echo ShopCore::encode($item.model->getName())}</a>
        </td>
        <td>
            <div class="price f-s_16 f_l">{echo $item.model->firstVariant->toCurrency()} <sub>{$CS}</sub><span class="d_b">{echo $item.model->firstVariant->toCurrency('Price', 1)} $</span></div>
        </td>
        <td>
            <div class="count">
                <input name="products[{$key}]" type="text" value="{$item.quantity}"/>
                <span class="plus_minus">
                    <button class="count_up inCartProducts">&#9650;</button>
                    <button class="count_down inCartProducts">&#9660;</button>
                </span>
            </div>
        </td>
        <td>
            <div class="price f-s_18 f_l">{echo $summary = $item.model->firstVariant->toCurrency() * $item.quantity} <sub>{$CS}</sub>
                <span class="d_b">{echo $summary_nextc = $item.model->firstVariant->toCurrency('Price', 1) * $item.quantity} $</span></div>
        </td>
        <td>
            <a href="{shop_url('cart/delete/'.$key)}" class="delete_text inCartProducts">&times;</a>
        </td>
    </tr>
    {$total     += $summary}
    {$total_nc  += $summary_nextc}
    {/foreach}
</tbody>
<tfoot>
    <tr>
        <td colspan="6">
            <div class="foot_cleaner">
                <div class="f_r">
                    <div class="price f-s_26 f_l">{$total} <sub>{$CS}</sub><span class="d_b">{$total_nc} $</span></div>
                </div>
                <div class="f_r sum">Сумма:</div>
            </div>
        </td>
    </tr>
</tfoot>
<input type="hidden" name="forCart" value="1" />
{else:}
    Корзина пуста
{/if}