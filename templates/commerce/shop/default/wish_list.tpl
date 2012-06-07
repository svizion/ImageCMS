{# Variables
# @var items
# @var capImage
# @var profile
#}
{$this->registerMeta('<META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW">')}
<div class="content">
    <div class="center">
        {if ShopCore::$ci->dx_auth->is_logged_in()===true}
        <h1>Список пожеланий</h1>
        {if !$items}
        <div class="comparison_slider">
            <div class="f-s_18 m-t_29 t-a_c">{echo ShopCore::t('Список пожеланий пуст')}</div>
        </div>
        {else:}
        <table class="cleaner_table forCartProducts" cellspacing="0">
            <caption>Добавлено продуктов  {if $items}({count($items)}){/if}</caption>
            <colgroup>
                <col width="140" span="1">
                <col width="371" span="1">
                <col width="130" span="1">
                <col width="224" span="1">
                <col width="138" span="1">
                <col width="28" span="1">
            </colgroup>
            <tbody>
                {foreach $items as $key=>$item}
                {$style = productInCart($cart_data, $item.model->getId(), $item.model->firstVariant->getId(), $item.model->firstVariant->getStock())}
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
                        <form action="{$style.link}" method="post">
                        <div class="buttons middle_fix {$style.class} buy">
                                <input type="hidden" value="wishes" id="buytype" name="buytype">
                                <input type="hidden" value="{echo $item.model->firstVariant->getId()}" name="variantId">
                                <input type="hidden" value="{echo $item.model->getId()}" name="productId">
                                <input type="hidden" value="1" name="quantity">
                                <input class="{$style.identif}" data-varid="{echo $item.model->firstVariant->getId()}" data-prodid="{echo $item.model->getId()}" type="submit" value="{strip_tags($style.message)}">
                                {form_csrf()}
                        </div>                        
                        </form>
                    </td>
                    <td>
                        <div class="price f-s_18 f_l">{echo $summary = $item.model->firstVariant->toCurrency() * 1} <sub>{$CS}</sub>
                            <span class="d_b">{echo $summary_nextc = $item.model->firstVariant->toCurrency('Price', 1) * 1} $</span></div>
                    </td>
                    <td>
                        <a href="{shop_url('wish_list/delete/' . $key)}" class="delete_plus">&times;</a>
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
            <input type="hidden" name="forCart" />
        </table>
        {/if}
        {else:}
            <h1>Вам необходимо авторизироватся</h1>
        {/if}
    </div>
</div>